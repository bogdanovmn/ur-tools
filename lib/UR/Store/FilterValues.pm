package UR::Store::FilterValues;

use strict;
use warnings;
use utf8;

use lib 'lib';
use Utils;

use base 'UR::Store';

sub constructor {
	my ($class, %p) = @_;

	my $self = UR::Store::connect($class);
	
	$self->{data} = {
		player_id => $p{player_id},
	};

	return $self;
}

sub char_main {
	my ($self, %p) = @_;

	my $selected_power = $p{selected_power} || 0;
	my $selected_damage = $p{selected_damage} || 0;

	my $res;
	if ($self->{data}->{player_id}) {
		$res = $self->query(
			qq|
				SELECT
					MIN(CH.power) min_power,
					MAX(CH.power) max_power,
					MIN(CH.damage) min_damage,
					MAX(CH.damage) max_damage
				FROM collection C
				JOIN chars CH ON CH.id = C.char_id
				WHERE C.player_id = ?
			|,
			[$self->{data}->{player_id}],
			{ only_first_row => 1 }
		);
	}
	else {
		$res = $self->query(
			qq|
				SELECT 
					MIN(CH.power) min_power,
					MAX(CH.power) max_power,
					MIN(CH.damage) min_damage,
					MAX(CH.damage) max_damage
				FROM chars CH 
			|,
			[],
			{ only_first_row => 1 }
		);
	}
	return {
		filter_power_values => [ 
			map { {power => $_, selected => ($_ eq $selected_power) } } 
				($res->{min_power}..$res->{max_power}) 
		],
		filter_damage_values => [ 
			map { {damage => $_, selected => ($_ eq $selected_damage)} } 
				($res->{min_damage}..$res->{max_damage})
		]
	};
}

sub clans {
	my ($self, $checked_values) = @_;

	unless (is_list($checked_values)) {
		$checked_values = [$checked_values];
	}

	my $result = $self->{data}->{player_id}
		# collection query
		? $self->query(
			qq|
				SELECT DISTINCT
					CL.id clan_id,
					CL.name clan_name,
					CL.pic_url clan_pic_url
				FROM collection C
				JOIN chars CH ON CH.id = C.char_id
				JOIN clan CL ON CL.id = CH.clan_id
				WHERE C.player_id = ?
				ORDER BY CL.id
			|,
			[$self->{data}->{player_id}]
		)
		# common query
		: $self->query(
			qq|
				SELECT 
					id clan_id,
					name clan_name,
					pic_url clan_pic_url
				FROM clan
				ORDER BY id
			|
		);

	if (scalar @$checked_values) {
		for my $r (@$result) {
			if (grep { $r->{clan_id} eq $_ } @$checked_values) {
				$r->{checked} = 1;
			}
		}
	}

	return $result;
}

sub levels {
	my ($self, $checked_values) = @_;

	my $result = $self->{data}->{player_id}
		# collection query
		? $self->query(
			qq|
				SELECT DISTINCT
					CH.level	
				FROM collection C
				JOIN chars CH ON CH.id = C.char_id
				WHERE C.player_id = ?
				ORDER BY CH.level
			|,
			[$self->{data}->{player_id}]
		)
		# common query
		: $self->query(
			qq|
				SELECT DISTINCT  
					CH.level
				FROM chars CH
				ORDER BY CH.level
			|
		);
	
	my @levels;
	for my $level (@$result) {
		push @levels, { level => $level };
		if (grep { $_ eq $level } @$checked_values) {
			$levels[-1]->{checked} = 1;
		}
	}
	
	return \@levels;
}

sub abilities {
	my ($self, $checked_value) = @_;

	my $result = $self->{data}->{player_id}
		# collection query
		? $self->query(
			qq|
				SELECT DISTINCT
					AM.rule_id,
					AM.rule
				FROM ability_map AM
				JOIN collection C ON C.char_id = AM.char_id
				WHERE C.player_id = ?
				ORDER BY AM.rule
				|,
			[$self->{data}->{player_id}]
		)
		# common query
		: $self->query(
			qq|
				SELECT DISTINCT  
					AM.rule_id,
					AM.rule
				FROM ability_map AM
				ORDER BY AM.rule
			|
		);
	
	for my $r (@$result) {
		if (grep {$_ eq $r->{rule_id}} @$checked_value) {
			$r->{checked} = 1;
		}
	}
	
	return $result;
}

sub abilities_prefix {
	my ($self, $checked_value) = @_;

	my $result = $self->{data}->{player_id}
		# collection query
		? $self->query(
			qq|
				SELECT DISTINCT
					AM.prefix_id,
					AM.prefix
				FROM ability_map AM
				JOIN collection C ON C.char_id = AM.char_id
				WHERE C.player_id = ?
				AND AM.prefix_id IS NOT NULL
				ORDER BY AM.prefix
			|,
			[$self->{data}->{player_id}]
		)
		# common query
		: $self->query(
			qq|
				SELECT DISTINCT  
					AM.prefix_id,
					AM.prefix
				FROM ability_map AM
				WHERE AM.prefix_id IS NOT NULL
				ORDER BY AM.prefix
			|
		);
	
	for my $r (@$result) {
		if (grep {$_ eq $r->{prefix_id}} @$checked_value) {
			$r->{checked} = 1;
		}
	}
	
	return $result;
}

sub option_mode {
	my ($self, $checked_value) = @_;
	return [ map {
		if ($_->{mode_id} eq $checked_value) {
			$_->{selected} = 1;
		}
		$_;
	} (
		{ mode_id => 0, mode => 'OFF' },
		{ mode_id => 1, mode => 'IN' },
		{ mode_id => 2, mode => 'NOT IN' },
	) ];		
}


1;
