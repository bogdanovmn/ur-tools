package UR::Store::Characters;

use strict;
use warnings;
use utf8;

use lib 'lib';
use UR::Client;
use Utils;

use base 'UR::Store';

sub constructor {
	my ($class, $info, %p) = @_;

	return UR::Store::connect($class);
}

sub _table_name {
	my ($self) = @_;
	return 'chars';
}

sub _fields_map {
	my ($self) = @_;
	return {
		abilityLongDescription => 'ability_long_desc',
		characterPictUrl => 'pic_url',
	};
}

sub load {
	my ($self, %p) = @_;

	my $filter = $p{filter};
	my @params;
	my $where_sql = '';
	
	if ($filter) {
		if ($filter->{id}) {
			my @id_list = grep {/^\d+$/} @{Utils::to_list($filter->{id})};
			if (@id_list) {
				$where_sql .= sprintf(' id IN (%s)', join(',', @id_list));
			}
		}

		if ($where_sql) {
			$where_sql = 'WHERE '. $where_sql;
		}
	}
	return $self->query(
		sprintf("SELECT * FROM %s %s", $self->_table_name, $where_sql),
	);
}

1
