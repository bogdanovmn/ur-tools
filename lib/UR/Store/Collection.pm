package UR::Store::Collection;

use strict;
use warnings;
use utf8;

use lib 'lib';
use UR::Client;
use Utils;

use base 'UR::Store';

sub constructor {
	my ($class, $player_id) = @_;

	my $self = UR::Store::connect($class);
	
	$self->{data} = {
		player_id => $player_id,
	};

	return $self;
}

sub _table_name {
	my ($self) = @_;
	return 'collection';
}

sub _fields_map {
	my ($self) = @_;
	return {
		id => 'char_id',
		totalOwnedCharacters => 'count'
	};
}

sub _clear {
	my ($self) = @_;
	$self->query(
		sprintf("DELETE FROM %s WHERE player_id = ?", $self->_table_name),
		[$self->{data}->{player_id}]
	);
}

sub update {
	my ($self, $data) = @_;
	
	$self->_clear;

	for (@$data) {
		$_->{player_id} = $self->{data}->{player_id};
	}

	$self->SUPER::update($data);
}

sub load {
	my ($self, %p) = @_;
	
	my $where = '';
	my @params = ($self->{data}->{player_id});

	if (@{$p{filter}->{level}}) {
		$where .= sprintf(' AND CH.level IN (%s) ', Utils::Sql::set_of_numbers($p{filter}->{level}));
	}

	if ($p{filter}->{power}) {
		$where .= ' AND CH.power >= ? ';
		push @params, $p{filter}->{power};
	}

	if ($p{filter}->{damage}) {
		$where .= ' AND CH.damage >= ? ';
		push @params, $p{filter}->{damage};
	}

	if (@{$p{filter}->{clan}}) {
		$where .= sprintf(' AND CH.clan_id IN (%s) ', Utils::Sql::set_of_numbers($p{filter}->{clan}));
	}

	if ($p{filter}->{elo}) {
		$where .= ' AND CH.is_valid_elo ';
	}

	if ($p{filter}->{standard}) {
		$where .= ' AND CH.is_standard ';
	}

	if (@{$p{filter}->{ability}}) {
		$where .= sprintf(' AND AM.rule_id IN (%s) ', Utils::Sql::set_of_numbers($p{filter}->{ability}));
	}
	if (@{$p{filter}->{ability_prefix}}) {
		$where .= sprintf(
			' AND (AM.prefix_id NOT IN (%s) OR AM.prefix_id IS NULL)', 
			Utils::Sql::set_of_numbers($p{filter}->{ability_prefix})
		);
	}

#webug [$where, \@params];	
	return $self->query(qq|
		SELECT 
			CH.id char_id,
			CH.name char_name,
			CH.power char_power,
			CH.damage char_damage,
			CH.ability char_ability,
			CL.bonus_desc char_bonus,
			CH.pic_url char_pic_url,
			CH.url char_url,
			CH.rarity char_rarity,
			CH.level char_level,
			CH.is_valid_elo char_is_valid_elo,
			CH.is_standard char_is_standard,
			AM.rule_id char_ability_rule_id,
			P.min char_price,
			CL.pic_url char_clan_pic_url,
			SUBSTRING_INDEX(
				SUBSTRING_INDEX(CL.pic_url, '/', -1),
				'_',
				1
			) char_clan_mnemonic,
			ROUND((3*CH.power + 2*CH.damage) / CH.level, 1) char_rate 
		FROM collection C
		JOIN chars CH ON CH.id = C.char_id
		JOIN clan CL ON CL.id = CH.clan_id
		LEFT JOIN ability_map AM ON AM.char_id = C.char_id
		LEFT JOIN prices P ON P.char_id = C.char_id
		WHERE C.player_id = ?
		$where
		ORDER BY char_rate DESC
		|,
		\@params
	);
}

sub load_dubles {
	my ($self, %p) = @_;
	
	my $where = '';
	my @params = ($self->{data}->{player_id});

#webug [$where, \@params];	
	return $self->query(qq|
		SELECT 
			CH.id char_id,
			CH.name char_name,
			DATE_FORMAT(CH.release_date, '%Y-%m-%d') char_release_date,
			CH.power char_power,
			CH.damage char_damage,
			CH.ability char_ability,
			CL.bonus_desc char_bonus,
			CH.pic_url char_pic_url,
			CH.url char_url,
			CH.rarity char_rarity,
			CH.level char_level,
			CH.is_valid_elo char_is_valid_elo,
			CH.is_standard char_is_standard,
			P.min char_min_price,
			P.avg char_avg_price,
			P.max char_max_price,
			C.count - 1 char_count,
			CL.pic_url char_clan_pic_url,
			SUBSTRING_INDEX(
				SUBSTRING_INDEX(CL.pic_url, '/', -1),
				'_',
				1
			) char_clan_mnemonic
		FROM collection C
		JOIN chars CH ON CH.id = C.char_id
		JOIN clan CL ON CL.id = CH.clan_id
		LEFT JOIN prices P ON P.char_id = C.char_id
		WHERE C.player_id = ?
		AND C.count > 1
		$where
		ORDER BY P.min DESC
		|,
		\@params
	);
}


1;
