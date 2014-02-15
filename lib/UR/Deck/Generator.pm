package UR::Deck::Generator;

use strict;
use warnings;
use utf8;

use lib 'lib';
use Utils;
use UR::Deck::Generator;
use UR::Store;
use UR::Store::Characters;

sub constructor {
	my ($class, %p) = @_;

	my $self = {
		size => $p{size} || 8,
		max_stars => $p{max_stars} || 25,
		char_max_stars => [
			$p{star2_max},
			$p{star3_max},
			$p{star4_max},
			$p{star5_max}
		],
		min_clans => $p{min_clans} || 1,
		elo => $p{elo} || 0,
		cr_max => $p{cr_max},
		mandatory_chars => Utils::to_list($p{mandatory_chars}),
		db => UR::Store->connect
	};

	$self->{half_size} = $self->{size} / $self->{min_clans};
	$self->{half_deck_min_stars};

	return bless $self, $class;
}

sub get {
	my ($self) = @_;

	my $chars_by_clan = $self->_group_chars_by_clan;
	my @clans = keys %$chars_by_clan;
	my @clan_half_decks;
	for my $clan (@clans) {
		push @clan_half_decks, $self->_load_half_decks([ map { $_->{id} } @{$chars_by_clan->{$clan}} ]);
	}

	for my $hd1 ($clan_half_decks[0]) {
		for my $hd2 ($clan_half_decks[1]) {
			next if $self->_filter($hd1, $hd2);
		}
	}
}

sub _filter {
	my ($self, $hd1, $hd2) = @_;
}

sub _group_chars_by_clan {
	my ($self) = @_;

	my $chars_data = UR::Store::Characters->constructor->load(
		filter => {
			id => $self->{mandatory_chars}
		}
	);
	my %result;
	foreach (@$chars_data) {
		push @{$result{$_->{clan_id}}}, $_;
	}
	return \%result;
}

sub _load_half_decks {
	my ($self, $clan_chars) = @_;

	die "bad params" unless @$clan_chars;
	
	my $where = 'DC1.char_id = ?';
	my @params = ($clan_chars->[0]);
	my $join = '';

	for (my $i = 1; $i < @$clan_chars; $i++) {
		$join .= sprintf("JOIN deck_char DC%d ON DC%d.deck_id = DC%d.deck_id\n", $i+1, $i+1, $i);
		$where .= sprintf(" AND DC%d.char_id = ? ", $i+1);
		push @params, $clan_chars->[$i];
	}

	return $self->{db}->query(qq|
		SELECT GD.id 
		FROM gen_deck GD
		JOIN deck_char DC1 ON DC1.deck_id = GD.id
		$join
		WHERE $where
		|,
		\@params
	);
}

1;
