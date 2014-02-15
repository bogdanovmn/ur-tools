package UR;

use Dancer ':syntax';

use UR::Action::Collection; 
use UR::Action::Update; 

our $VERSION = '0.1';

sub controller {
	my (%p) = @_;

	my $action_class = 'UR::Action::'. $p{action};

	return template 
		$p{template},
		$action 
			? $action_class->main(params)
			: {};
}


hook 'before' => sub {
	# Если есть токен - ок
	# Иначе перенаправляем на страницу с просьбой получить разрешение 
	# на использование ресурсов игры
};

get '/collection' => sub {
	controller( template => 'collection', action => 'Collection' );
};

get '/dubles' => sub {
	controller( template => 'dubles', action => 'Collection' );
};

get '/update' => sub {
	controller( action => 'Update' );
	redirect '/collection';
};

true;
