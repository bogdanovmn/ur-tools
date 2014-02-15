package UR::Action::Collection;

use strict;
use warnings;
use utf8;

use lib 'lib';
use UR::Store::Collection;
use UR::Store::FilterValues;
use Utils;


sub main {
	my ($class, $params) = @_;

	my %filter = (
		clan => [ $params{clan} ],
		level => [$params{level}] || [5],
		power => $params{power} || 1,
		damage => $params{damage} || 1,
		elo => $params{elo} || 0,
		standard => $params{standard} || 0,
		ability => [$params{ability}] || [0],
		ability_prefix => [$params{ability_prefix}] || [0],
	);

	my $collection = UR::Store::Collection->constructor($p->{player_id});
	my $chars = $collection->load(
		filter => \%filter
	);

	my $filter_values = UR::Store::FilterValues->constructor(player_id => $p->{player_id});

	return {
		elo => $filter{elo},
		standard => $filter{standard},
		chars => $chars,
		filter_clans => $filter_values->clans($filter{clan}),
		filter_level_values => $filter_values->levels($filter{level}),
		%{$filter_values->char_main(selected_power => $filter{power}, selected_damage => $filter{damage})},
		filter_ability => $filter_values->abilities($filter{ability}),
		filter_ability_prefix => $filter_values->abilities_prefix($filter{ability_prefix}),
	};
}
