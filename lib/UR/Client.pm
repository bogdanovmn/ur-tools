package UR::Client;

use strict;
use warnings;
use utf8;

use UR_Api;

use Utils;
use UR::Store::Player;

use Net::OAuth::Client;
use Net::OAuth::AccessToken;
use JSON::XS;

sub new {
	my ($class, %p) = @_;
	
	my $self = {
		session_method => $p{session_method}
	};

	$self->{consumer} = Net::OAuth::Client->new(
		UR_Api::CONSUMER_KEY,
		UR_Api::CONSUMER_SECRET,
		request_token_path => UR_Api::URL_REQUEST_TOKEN,
		access_token_path  => UR_Api::URL_ACCESS_TOKEN,
		authorize_path     => UR_Api::URL_AUTHORIZE,
		callback => $p{callback} || UR_Api::URL_CALLBACK,
		session => sub { 
			$self->{session_method}(@_); 
		}
	);
	
	return bless $self, $class;
}

sub _session {
	my ($self, @params) = @_;
	return $self->{session_method}(@params);
}

sub authorize {
	my ($self) = @_;
	
	if ($self->_session('player_id')) {
		return $self->_session('player_id');
	}
	else {
		return 0;
	}
}

sub auth_url {
	my ($self) = @_;

	return $self->{consumer}->authorize_url;
}

sub player_id {
	my ($self) = @_;
	return $self->_session('player_id');
}

sub is_success_access {
	my ($self, $oauth_token) = @_;
	
	if ($self->_session('player_id')) {
		return 1;
	}
	
	my $access_token = eval {
		$self->{consumer}->get_access_token($oauth_token, '');
	};

	if ($@) {
		$self->{error_msg} = $@;
		return 0;
	}
	
	unless ($access_token) {
		$self->{error_msg} = $self->{consumer}->errstr;
		return 0;
	}
	
	$self->_session('access_token', $access_token->{token});
	$self->_session('access_token_secret', $access_token->{token_secret});

	$self->_init_player({
		token => $access_token->{token},
		token_secret => $access_token->{token_secret}
	});

	return 1;
}

sub _init_player {
	my ($self, $access_keys) = @_;
	
	my $player_info = $self->query('general.getPlayer');
	my $player = UR::Store::Player->new(
		$player_info->{context}->{player},
		access_keys => $access_keys
	);
	$player->update;
	$self->_session('player_id', $player->id);
}

sub _access_token {
	my ($self) = @_;
	return Net::OAuth::AccessToken->new(
		client => $self->{consumer},
		token => $self->_session('access_token'),
		token_secret => $self->_session('access_token_secret')
	);
}

sub query {
	my ($self, $method, $params, $filters) = @_;
	
	my $call_params = [{
		call => $method,
		params => $params,
		is_hash($filters) ? %$filters :()
	}];
	my $call_json = JSON::XS::encode_json($call_params);
	
	my $res = $self->_access_token->post(
		UR_Api::URL_API."?request=$call_json" 
	);
	
	unless ($res->is_success) {
		webug {
			error_msg => $res->decoded_content,
			call_params => $call_params,
			json => $call_json,
			#request => $res->request->as_string,
			#response => $res->as_string
		};
    }
	my $json = $res->decoded_content;
	return JSON::XS::decode_json($json)->{$method};
}

sub error_msg {
	my ($self) = @_;
	return $self->{error_msg};
}


1;
