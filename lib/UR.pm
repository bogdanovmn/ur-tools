package UR;

use Dancer ':syntax';

use UR::Client;
use UR::Action::Collection; 
use UR::Action::Update; 
use UR::Action::AuthCallback; 
use Utils;

our $VERSION = '0.1';

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

#webug [request->body(), params()];
#webug [$action_name, $template_name, $action_params];
	# Если задан шаблон - возращаем результат рендера
	# Если шаблона не задан - возвращаем реультат экшена
	return $template_name
		? _template( 
			$template_name,
			$action_name
				? $action_class->main($action_params)
				: {}
		)
		: $action_class->main($action_params);
}

sub _api_client {
	return UR::Client->new(
		callback => request->base(). 'callback',
		session_method => \&session
	);
}

hook 'before' => sub {
	# Если есть токен - ок
	# Иначе перенаправляем на страницу с просьбой получить разрешение 
	# на использование ресурсов игры
	my $path = request->path();
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
			redirect $consumer->auth_url;
		}
	}
};


get '/callback' => sub {
	if ( controller(action => 'AuthCallback') ) {
		redirect '/collection';
	}
	else {
		redirect '/';
	}
};

get '/collection' => sub {
	controller( template => 'collection', action => 'Collection' );
};

post '/collection' => sub {
	#webug [request->body(), params()];
	controller( template => 'collection', action => 'Collection' );
};

get '/dubles' => sub {
	controller( template => 'dubles', action => 'Collection' );
};

get '/update' => sub {
	controller( action => 'Update' );
	redirect '/collection';
};

get '/' => sub {
	controller( template => 'index' );
};

true;
