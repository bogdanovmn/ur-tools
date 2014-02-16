package UR::Action::Update;

use strict;
use warnings;
use utf8;

use UR::Import;
use Utils;


sub main {
	my ($class, $params) = @_;

	my $import = UR::Import->new(consumer => $params->{consumer});
	#$import->clans;
	#$import->characters;
	$import->prices;
	#$import->player;
	$import->collection;
	#$import->formats;
}


1;
