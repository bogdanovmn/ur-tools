package UR::Store::Clans;

use strict;
use warnings;
use utf8;

use lib 'lib';
use Utils;

use base 'UR::Store';

sub constructor {
	my ($class, $info, %p) = @_;

	return UR::Store::connect($class);
}

sub _table_name {
	my ($self) = @_;
	return 'clan';
}

sub _fields_map {
	my ($self) = @_;
	return {
		bonusLongDescription => 'bonus_long_desc',
		bonusDescription => 'bonus_desc',
		clanPictUrl => 'pic_url'
	};
}

sub update {
	my  ($self, $data) = @_;

	$self->_clear;
	$self->SUPER::update($data);
}

sub load {
	my ($self) = @_;

	return $self->query(
		sprintf(qq|
			SELECT 
				id clan_id,
				name clan_name,
				pic_url clan_pic_url
				FROM %s
				ORDER BY id
			|, 
			$self->_table_name
		)
	);
}

1
