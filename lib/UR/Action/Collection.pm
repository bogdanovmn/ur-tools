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
		clan => defined $params->{clan} ? Utils::to_list($params->{clan}) : [],
		level => defined $params->{level} ? Utils::to_list($params->{level}) : [],
		power => $params->{power} || 1,
		damage => $params->{damage} || 1,
		elo => $params->{elo} || 0,
		standard => $params->{standard} || 0,
		ability => defined $params->{ability} ? Utils::to_list($params->{ability}) : [],
		ability_prefix => defined $params->{ability_prefix} ? Utils::to_list($params->{ability_prefix}) : [],
	);

	my $player_id = $params->{player_id};
	my $collection = UR::Store::Collection->constructor($player_id);
	my $chars = $collection->load(
		filter => \%filter
	);

	my $filter_values = UR::Store::FilterValues->constructor(player_id => $player_id);
	
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

1;
