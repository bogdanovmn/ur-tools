package Utils::Sql;

use strict;
use warnings;


sub update_by_hash {
	my ($hash) = @_;
	
	my @values;
	my $sql = "";

	while (my ($k, $v) = each %$hash) {
		$sql .= " $k = ?,";
		push @values, $v;
	}
	chop $sql;

	return { sql => $sql, values => \@values };
}

sub update_by_list {
	my ($list_of_hash) = @_;

	return unless scalar @$list_of_hash;

	my @params;
	my $values_sql = "";
	my @keys = keys %{$list_of_hash->[0]};

	my $fields_sql = '('. join(",", @keys). ')';

	for my $hash (@$list_of_hash) {
		$values_sql .= '(';
		for my $k (@keys) {
			push @params, $hash->{$k};
			$values_sql .= '?,';
		}
		chop $values_sql;
		$values_sql .= '),';
	}
	chop $values_sql;

	return { fields => $fields_sql, values => $values_sql, params => \@params };
}

sub set_of_numbers {
	my ($numbers) = @_;
	return join ',', grep {/^\d+$/} @$numbers;
}

1;
