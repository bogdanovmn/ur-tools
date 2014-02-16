package UR::Import;

use strict;
use warnings;
use utf8;

use lib 'lib';
use UR::Store::Player;
use UR::Store::Collection;
use UR::Store::Characters;
use UR::Store::Clans;
use UR::Store::Prices;
use UR::Store::AbilityMap;
use Utils;
use Cache;
use Date::Format;


sub new {
	my ($class, %p) = @_;

	my $self = {
		consumer => $p{consumer},
		cache => Cache->constructor(
			fresh_time => Cache::FRESH_TIME_MINUTE * 10,
			#storage => './cache/api_calls'
			storage => '/home/users1/r/rednikovp/domains/ur.rednikovp.myjino.ru/cache'
		)
	};

	return bless $self, $class;
}

sub query {
	my ($self, %p) = @_;
	if ($p{cache}) {
		my $tag = $p{cache}->{tag} || '';
		return $self->{cache}->get(
			$tag.$p{params}->[0],
			sub { $self->{consumer}->query(@{$p{params}}) },
			$p{cache}->{fresh_time}
		);
	}

	return $self->{consumer}->query(@{$p{params}});
}

sub player {
	my ($self) = @_;
	
	my $data = $self->query(
		params => ['general.getPlayer'],
		cache => { fresh_time => Cache::FRESH_TIME_DAY }
	);
	
	my $player = UR::Store::Player->new($data->{context}->{player});
	$player->update;
}

sub collection {
	my ($self) = @_;
	
	my $player_id = $self->{consumer}->authorize;
	
	my $data = $self->query(
		params => [
			'collections.getClanSummary', 
			{ ownedOnly => 1 },
			{ itemsFilter => ['id', 'totalOwnedCharacters'] }
		],
		cache => {
			fresh_time => Cache::FRESH_TIME_HOUR,
			tag => $player_id
		}
	);
	
	my $collection = UR::Store::Collection->constructor($player_id);
	$collection->update($data->{items});
}

sub formats {
	my ($self) = @_;

	my $data = $self->query(
		params => ['characters.getDeckFormats'],
	);
	debug $data;
}

sub prices {
	my ($self) = @_;

	my $chars_ids_chunks = Utils::chunks(
		[map { $_->{id} } @{UR::Store::Characters->constructor->load}],
		400
	);
	my $prices = UR::Store::Prices->constructor;

	for my $chars_ids (@$chars_ids_chunks) {	
		my $data = $self->query(
			params => [
				'market.getCharactersPricesCurrent',
				{ charactersIDs => $chars_ids },
				{ itemsFilter => [qw|
					id
					min
					max
					avg
				  |]
				}
			]
		);
		$prices->update($data->{items});
	}
}

sub clans {
	my ($self) = @_;

	my $data = $self->query(
		params => [
			'characters.getClans',
			{},
			{ itemsFilter => [qw|
				id
				name
				description
				bonusLongDescription
				bonusDescription
				clanPictUrl
			  |]
			}
		]
	);
	my $clans = UR::Store::Clans->constructor;
	$clans->update($data->{items});
}

sub characters {
	my ($self) = @_;
	
	my $data = $self->query(
		params => [
			'characters.getCharacters', 
			{ maxLevels => 1 },
			{ itemsFilter => [qw|
				id
				name
				damage
				penalty
				abilityLongDescription
				is_standard
				kind
				is_tradable
				characterPictUrl
				power
				url
				ability
				picture_url
				ability_id
				bank_price
				release_date
				description
				level
				clan_id
				rarity
				distrib
				is_valid_elo	
			  |]
			}
		],
		cache => { fresh_time => Cache::FRESH_TIME_DAY }
	);
	
	my $characters = UR::Store::Characters->constructor;
	for (@{$data->{items}}) {
		$_->{release_date} = Date::Format::time2str("%Y-%m-%d", $_->{release_date});
	}
	$characters->update($data->{items});
	
	my $ability_map = UR::Store::AbilityMap->constructor;
	$ability_map->update($data->{items});
}


1;
