package UR::Store::Player;

use strict;
use warnings;
use utf8;

use lib 'lib';
use UR::Client;
use Utils;

use base 'UR::Store';

sub new {
	my ($class, $info, %p) = @_;

	my $self = UR::Store::connect($class);
	
	$self->{data} = {
		id => $info->{id},
		name => $info->{name},
		grade => $info->{grade},
		locale => $info->{locale},
		flag_url => $info->{flagURL},
		url => $info->{url},
		clintz => $info->{clintz},
		level => $info->{level}
	};

	$self->{keys} = $p{access_keys};

	return bless  $self, $class;
}

sub choose {
	my ($class, $player_id) = @_;
	
	my $self = UR::Store::connect($class);
	
	$self->{data} = { 
		id => $player_id
	};

	return bless $self, $class;

}

sub _table_name {
	my ($self) = @_;
	return 'player';
}

sub exists {
	my ($self) = @_;

	my $result = $self->query(
		qq| SELECT id FROM $self->_table_name WHERE id = ? |,
		[$self->id]
	);
	
	return scalar @$result;
}

sub load {
	my ($self) = @_;

	return $self->query(qq|
		SELECT 
			id player_id,
			name player_name,
			grade player_grade,
			level player_level,
			url player_url,
			clintz player_clintz
		FROM player 
		WHERE id = ?
		|, 
		[$self->id],
		{only_first_row => 1}
	);
}

sub _update_access_keys {
	my ($self) = @_;

	if (keys %{$self->{keys}}) { 
		$self->SUPER::update(
			{
				%{$self->{keys}},
				player_id => $self->id
			},
			'player_access_keys'
		);
	}
}

sub update {
	my ($self) = @_;
	
	$self->SUPER::update($self->{data}, $self->_table_name);
	$self->_update_access_keys;
}

sub id {
	my ($self) = @_;
	return $self->{data}->{id};
}

1;
