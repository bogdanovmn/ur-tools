package DB;

use DBI;
use strict;
use warnings;

use Time::HiRes;


my $__STATISTIC = {
	sql_count => 0,
	sql_time => 0,
	db_connect_time => 0,
	db_connections => 0,
	queries_details => []
};

my $__DBH = undef;

sub connect {
	my ($class, %p) = @_;
	
	unless ($__DBH) {
		my $begin_time = Time::HiRes::time;
		$__DBH = DBI->connect(
			sprintf('dbi:mysql:%s:%s', $p{name}, $p{host}), 
			$p{user}, 
			$p{pass}
		) or die("DB connect error! $!");
		$__DBH->do("SET NAMES utf8");
		$__DBH->do("SET SQL_BIG_SELECTS=1");
		$__STATISTIC->{db_connect_time} += Time::HiRes::time - $begin_time;
		$__STATISTIC->{db_connections}++;
	}

	my $self = { 
		dbh => $__DBH, 
		ip => $ENV{REMOTE_ADDR},
		sql_empty_result => 1
	};
	
	$self->{console} = $p{console} || 0;

	return bless $self, $class;
}

sub query {
	my ($self, $sql, $params, $settings) = @_;

	my $sql_error_msg = $settings->{error_msg} || "SQL query error [". (caller(1))[3]. "]";
	my $sql_debug = $settings->{debug} || 0;
	my $only_field = $settings->{only_field} || 0;
	my $only_first_row = $settings->{only_first_row} || 0;
	my $return_last_id = $settings->{return_last_id} || 0;

	my $begin_time = Time::HiRes::time;
	my $sth = $self->_execute_sql($sql, $params, $settings);
	$__STATISTIC->{sql_time} += Time::HiRes::time - $begin_time;
	$__STATISTIC->{sql_count}++;

	if ($sql_debug) {
		use Data::Dumper; warn Dumper(\@_);
	}


	# Explain statistic BEGIN
	#$settings->{explain_statistic} = 1;
	#$self->explain_query($sql, $params, $settings);
	# Explain statistic END

	if ($return_last_id and $sql =~ /^\s*insert/i) {
		$sth->finish;
		return $self->{dbh}->last_insert_id(undef, undef, undef, undef);
	}
	
	if ($sql =~ /^\s*(select|show)/i) {	
		my @result = ();
		while (my $row = $sth->fetchrow_hashref) {
			if ($only_field) {
				$sth->finish;
				return $row->{$only_field};
			}
			
			if ($only_first_row) {
				$sth->finish;
				return $row;
			}

			push(@result, keys %$row > 1 ? $row : (values %$row)[0]);
		}
		$sth->finish;
		
		$self->{sql_empty_result} = scalar @result eq 0; 

		return $only_first_row ? undef : \@result;
	}
		
	return 1;
}
#
# Explain command
#
sub explain_query {
	my ($self, $sql, $params, $settings) = @_;

	my $sth = $self->_execute_sql('EXPLAIN '. $sql, $params, $settings);

	my @result = ();
	my $total_rows = 1;
	my $extra_total = '';
	my $type_total = '';
	while (my $line = $sth->fetchrow_hashref) {
		$total_rows *= $line->{rows};
		$extra_total .= $line->{Extra};
		$type_total .= $line->{type};
		push(@result, $line);
	}
	
	$sth->finish;

	my $explain_data = {
		caller => (caller(2))[3],
		details => \@result, 
		nice_total_rows => short_number($total_rows),
		total_rows => $total_rows 
	};
	if ($settings->{explain_statistic}) {
		if ($total_rows > 100 or $type_total =~ /ALL/ or $extra_total =~ /temporary|filesort/) {
			push(@{$__STATISTIC->{queries_details}}, $explain_data);
		}
	}

	return $explain_data;
}
#
# Execute sql
#
sub _execute_sql {
	my ($self, $sql, $params, $settings) = @_;
	
	my $sth = $self->{dbh}->prepare($sql);
	$sth->execute(@$params);
	
	if ($sth->err) {
		die $settings->{error_msg};
    }

	return $sth;
}
#
# Check last resultset length
#
sub empty_result_set {
	my ($self) = @_;
	return $self->{sql_empty_result};
}
#
# Return statistic data
#
sub statistic {
	return $__STATISTIC;
}

1;
