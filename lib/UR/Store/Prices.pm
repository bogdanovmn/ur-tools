package UR::Store::Prices;

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
	return 'prices';
}

sub _fields_map {
	my ($self) = @_;
	return {
		id => 'char_id'
	};
}

sub load {
	my ($self) = @_;

	return $self->query(
		sprintf("SELECT * FROM %s", $self->_table_name),
	);
}

1
