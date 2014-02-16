package Utils;

use strict;
use warnings;
use utf8;

use Data::Dumper;

require Exporter;
our @ISA = qw| Exporter |;
our @EXPORT = (qw|
	debug
	webug
	is_list
	is_hash
	to_list
|);


sub _dumper {
	my @params = @_;

	$Data::Dumper::Useqq = 1;
	$Data::Dumper::Indent = 2;
	{ 
		no warnings 'redefine';
		sub Data::Dumper::qquote {
			my $s = shift;
			return "'$s'";
		}
	}
	return Dumper(@params);
}

sub debug {
	my ($var) = @_;
	warn _dumper($var);
	exit;
}

sub webug {
	my ($var) = @_;
	
	print "Content-Type: text/html; charset: utf-8;\n\n";
	printf "<html><head><meta charset='utf-8'></head><body><pre>%s</pre></body></html>", _dumper($var);
	#print _dumper($var);
	exit;
}

sub is_list {
	ref shift eq 'ARRAY';
}

sub is_hash {
	ref shift eq 'HASH';
}

sub rename_fields {
	my ($data, $map) = @_;

	return unless is_hash $map;
	return unless scalar keys %$map;

	if (is_hash $data) {
		$data = [$data];
	}

	for my $d (@$data) {
		while (my ($orig_key, $new_key) = each %$map) {
			if (exists $d->{$orig_key}) {
				$d->{$new_key} = $d->{$orig_key};
				delete $d->{$orig_key};
			}
		}
	}
}

sub to_list {
	my ($x) = @_;

	unless (is_list $x) {
		$x = [$x];
	}

	return $x;
}

sub chunks {
	my ($list, $size) = @_;
	my @result;

	return $list if !$size || scalar(@$list) <= $size;

	while (scalar @$list) {
		push @result, [splice(@$list, 0, $size)];
	}

	return \@result;
}


1;
