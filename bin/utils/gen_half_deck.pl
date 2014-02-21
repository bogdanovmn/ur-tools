#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Algorithm::Combinatorics qw(combinations);

use FindBin;
use lib $FindBin::Bin. '/../lib';

use UR::Store::Characters;
use UR::Store::Clans;
use Utils;

use constant HALF_DECK_SIZE => 4;

my $_DECK_ID = 1;

my $store = UR::Store->connect;

my $chars_data = UR::Store::Characters->constructor->load;
my $chars_helper = { map { $_->{id} => $_ } @$chars_data };
my @clans = map { $_->{clan_id} } @{UR::Store::Clans->constructor->load};



sub gen_clan {
	my ($clan_id) = @_;
	
	my @chars_ids = map { $_->{id} } grep { $_->{clan_id} eq $clan_id } @$chars_data;

	my $c_iter = combinations(\@chars_ids, 4);
	my $i = 0;
	my $sql_deck_values = '';
	my $sql_deck_char_values = '';
	while (my $chars = $c_iter->next) {
		my $stars = 0;
		my $common = 0;
		my $uncommon = 0;
		my $rare = 0;
		my $legend = 0;
		my $cr = 0;
		my $rate = 0;
		my $elo = 1;
		my $standard = 1;
		
		foreach (@$chars) {
			my $info = $chars_helper->{$_};
			$stars +=	$info->{level};
			$common++	if $info->{rarity} eq 'c';
			$uncommon++ if $info->{rarity} eq 'u';
			$rare++		if $info->{rarity} eq 'r';
			$legend++	if $info->{rarity} eq 'l';
			$rate +=	($info->{power}*3 + $info->{damage}*2) / $info->{level};
			$elo = 0	unless $info->{is_valid_elo};
			$standard = 0 unless $info->{is_standard};
			$cr++		if $info->{kind} eq 'collector';
			
			$sql_deck_char_values .= qq|('$_DECK_ID','$_'),|; 
		}

		$sql_deck_values .= qq| ('$_DECK_ID', '$clan_id', '$stars', '$common', '$uncommon', '$rare', '$legend', '$cr', '$rate', '$elo', '$standard'),|;
		$_DECK_ID++;

		$i++;

		if ($i % 10000 == 0) {
			chop $sql_deck_values;
			chop $sql_deck_char_values;
			$store->query(qq|
				INSERT INTO gen_deck (id, clan_id, stars, common_count, uncommon_count, rare_count, legend_count, cr_count, rate, elo, standard) VALUES $sql_deck_values
			|);

			$store->query(qq|
				INSERT INTO deck_char (deck_id, char_id) VALUES $sql_deck_char_values
			|);
			$sql_deck_values = '';
			$sql_deck_char_values = '';
		}
	}
	if ($sql_deck_values) {
		chop $sql_deck_values;
		chop $sql_deck_char_values;
		$store->query(qq|
			INSERT INTO gen_deck (id, clan_id, stars, common_count, uncommon_count, rare_count, legend_count, cr_count, rate, elo, standard) VALUES $sql_deck_values
		|);

		$store->query(qq|
			INSERT INTO deck_char (deck_id, char_id) VALUES $sql_deck_char_values
		|);
		$sql_deck_values = '';
		$sql_deck_char_values = '';

	}
	printf "[ clan_id = %d ] chars: %d\ntotal combinations(%d): %d\n\n", $clan_id, scalar @chars_ids, HALF_DECK_SIZE, $i;
}

#gen_clan(44);
#exit;
for my $clan_id (@clans) {
	gen_clan($clan_id);
}


