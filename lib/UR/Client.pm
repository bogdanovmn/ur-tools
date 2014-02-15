package UR::Client;

use strict;
use warnings;
use utf8;

use lib 'conf';
use UR_Api;

use lib 'lib';
use Utils;
use UR::Store::Player;

use CGI;
use CGI::Session;
use Net::OAuth::Client;
use Net::OAuth::AccessToken;
use JSON::XS;

sub new {
	my ($class, %p) = @_;

	my $self = {
		session => CGI::Session->new
	};
	$self->{consumer} = Net::OAuth::Client->new(
		UR_Api::CONSUMER_KEY,
		UR_Api::CONSUMER_SECRET,
		request_token_path => UR_Api::URL_REQUEST_TOKEN,
		access_token_path  => UR_Api::URL_ACCESS_TOKEN,
		authorize_path     => UR_Api::URL_AUTHORIZE,
		callback => UR_Api::URL_CALLBACK,
		session => sub { 
			$self->{session}->param(@_); 
		}
	);
	
	return bless $self, $class;
}

sub authorize {
	my ($self) = @_;
	
	if ($self->{session}->param('player_id')) {
		return $self->{session}->param('player_id');
	}
	else {
		$self->{session}->clear;
		$self->{session}->expire('1M');
		
		my $auth_url = $self->{consumer}->authorize_url;
		
		print CGI::redirect(
			-url => $auth_url,
			-cookie => CGI::cookie(CGISESSID => $self->{session}->id)
		);
		exit;
	}
}

sub player_id {
	my ($self) = @_;
	return $self->{session}->param('player_id');
}

sub is_success_access {
	my ($self) = @_;
	
	if ($self->{session}->param('player_id')) {
		return 1;
	}

	my $cgi = CGI->new;
	my $verifier = $cgi->param('oauth_verifier') || '';
	my $token = $cgi->param('oauth_token');
	
	my $access_token = eval {
		$self->{consumer}->get_access_token(
			$token,
			$verifier,
		);
	};

	if ($@) {
		$self->{error_msg} = $@;
		return 0;
	}
	
	unless ($access_token) {
		$self->{error_msg} = $self->{consumer}->errstr;
		return 0;
	}
	
	$self->{session}->clear;
	$self->{session}->param('access_token', $access_token->{token});
	$self->{session}->param('access_token_secret', $access_token->{token_secret});
	$self->{session}->flush;

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
	$self->{session}->param('player_id', $player->id);
}

sub _access_token {
	my ($self) = @_;
	return Net::OAuth::AccessToken->new(
		client => $self->{consumer},
		token => $self->{session}->param('access_token'),
		token_secret => $self->{session}->param('access_token_secret')
	);
}

sub query {
	my ($self, $method, $params, $filters) = @_;
	
	my $call_params = [{
		call => $method,
		params => $params,
		(is_hash($filters) ? %$filters : undef)
	}];
	my $call_json = JSON::XS::encode_json($call_params);
	
	my $res = $self->_access_token->post(
		UR_Api::URL_API."?request=$call_json" 
	);
	
	unless ($res->is_success) {
		debug {
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
