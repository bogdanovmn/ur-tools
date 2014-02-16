package UR::Action::AuthCallback;

use strict;
use warnings;
use utf8;

use UR::Client;
use UR::Import;
use Utils;


sub main {
	my ($class, $params) = @_;

	my $consumer = $params->{consumer};
	if ($consumer->is_success_access($params->{oauth_token})) {
		my $import = UR::Import->new(consumer => $consumer);
		$import->player;
		return 1;
	}
	else {
		webug $consumer->error_msg;
		return 0;
	}
}

1;
