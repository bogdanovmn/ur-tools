package UR;

use Dancer ':syntax';

use UR::Client;

use UR::Action::Collection; 
use UR::Action::Dubles; 
use UR::Action::BoosterHelper; 
use UR::Action::Update; 
use UR::Action::AuthCallback; 

use Utils;

our $VERSION = '0.1003';

sub _template {
	my $content = Dancer::template(@_);
	utf8::decode($content);
	return $content;
}

sub controller {
	my (%p) = @_;
	
	my $template_name = $p{template} || '';
	my $action_name = $p{action} || '';
	
	my $action_class = 'UR::Action::'. $action_name;
	my $action_params = {
		Dancer::params(),
		%{Dancer::vars()}
	};

	# Если задан шаблон - возращаем результат рендера
	# Если шаблона не задан - возвращаем реультат экшена
	if ($template_name) {
		return _template( 
			$template_name,
			$action_name
				? $action_class->main($action_params)
				: {}
		);
	}
	else {
		return $action_class->main($action_params);
	}
}

sub _api_client {
	return UR::Client->new(
		callback => 'http://'. request->base->host. '/callback',
		session_method => \&session
	);
}

hook 'before' => sub {
	# Если есть токен - ок
	# Иначе перенаправляем на страницу с просьбой получить разрешение 
	# на использование ресурсов игры
	my $path = request->path_info();
	if ($path eq '/callback') {
		var consumer => _api_client();
	}
	elsif ($path ne '/') {
		my $consumer = _api_client();
		if ($consumer->authorize) {
			var player_id => $consumer->player_id;
			var consumer => $consumer;
		}
		else {
			session->destroy;
			redirect $consumer->auth_url;
		}
	}
};

hook 'before_template_render' => sub {
	my ($template_params) = @_;

	if (vars->{player_id}) {
		my $player_data = UR::Store::Player->choose(vars->{player_id})->load;
		while (my ($k, $v) = each %{$player_data}) {
			$template_params->{$k} = $v;
		}
	}
};

get '/callback' => sub {
	if ( controller(action => 'AuthCallback') ) {
		redirect '../collection';
	}
	else {
		redirect '../';
	}
};

any '/collection' => sub {
	controller( template => 'collection', action => 'Collection' );
};


get '/dubles' => sub {
	controller( template => 'dubles', action => 'Dubles' );
};

get '/booster' => sub {
	controller( template => 'booster', action => 'BoosterHelper' );
};

get '/update' => sub {
	controller( action => 'Update' );
	redirect '../collection';
};

get '/' => sub {
	controller( template => 'index' );
};

true;
