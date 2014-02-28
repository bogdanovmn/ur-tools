package UR::Action::Update;

use strict;
use warnings;
use utf8;

use UR::Import;
use Utils;


sub main {
	my ($class, $params) = @_;

	my $import = UR::Import->new(consumer => $params->{consumer});
	
	if ($params->{target} eq 'clan') {
		$import->clans;
	}
	elsif ($params->{target} eq 'chars') {
		$import->characters;
	}
	elsif ($params->{target} eq 'prices') {
		$import->prices;
	}
	elsif ($params->{target} eq 'player') {
		$import->player;
		$import->collection;
	}
	else {
		webug 'wrong update target';
	}

	#$import->formats;
}


1;
