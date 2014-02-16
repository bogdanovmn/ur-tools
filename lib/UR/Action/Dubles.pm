package UR::Action::Dubles;

use strict;
use warnings;
use utf8;

use UR::Store::Collection;
use Utils;


sub main {
	my ($class, $params) = @_;

	my $player_id = $params->{player_id};
	my $collection = UR::Store::Collection->constructor($player_id);
	my $chars = $collection->load_dubles;
	
	return {
		chars => $chars,
	};
}

1;
