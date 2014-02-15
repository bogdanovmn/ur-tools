package Render;

use strict;
use warnings;
use HTML::Template;

sub new {
	my ($class, $tpl_file) = @_;
	
	my $self = {
		tpl => HTML::Template->new(
			filename => 'tpl/'.$tpl_file. ".tpl",
			default_escape => 'HTML',
			loop_context_vars => 1,
			global_vars => 1,
			die_on_bad_params => 0
		)
	};

	return bless $self, $class;
}

sub params {
	my ($self, %p) = @_;
	
	$self->{tpl}->param(
		%p,
		ur_domain => 'http://beta.urban-rivals.com'
	);
}

sub show {
	my ($self) = @_;
	
	print "Content-Type: text/html; charset: utf8;\n\n";
	print $self->{tpl}->output;
}


1;
