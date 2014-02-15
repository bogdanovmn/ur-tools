package UR::Store;

use strict;
use warnings;
use utf8;

use lib 'conf';
use DB_CONF;

use lib 'lib';
use DB;
use Utils::Sql;
use Utils;


sub connect {
	my ($class, %p) = @_;

	my $self = {
		db => DB->connect(
			name => DB_CONF::NAME,
			host => DB_CONF::HOST,
			user => DB_CONF::USER,
			pass => DB_CONF::PASS
		) #or die "Can't connect to DB! $!\n"
	};

	return bless $self, $class;
}

sub _table_name {
	my ($self) = @_;
	return undef;
}

sub _fields_map {
	my ($self) = @_;
	return {};
}

sub _clear {
	my ($self) = @_;
}

sub query {
	my ($self, @params) = @_;
	return $self->{db}->query(@params);
}

sub update {
	my ($self, $data, $table_name) = @_;
	
	if (is_hash $data) {
		$data = [$data];
	}

	Utils::rename_fields($data, $self->_fields_map);
	
	$table_name ||= $self->_table_name;
	my $sql_meta = Utils::Sql::update_by_list($data);
	$self->query(qq|
		REPLACE INTO $table_name
		$sql_meta->{fields}
		VALUES
		$sql_meta->{values}
		|,
		$sql_meta->{params},
		{ debug => 0 }
	);
}


1;
