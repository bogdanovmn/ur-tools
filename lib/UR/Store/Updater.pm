package UR::Store::Updater;

use strict;
use warnings;
use utf8;

use lib 'lib';

use base 'UR::Store';


sub chars {
	my ($self, $chars) = @_;
	for my $char (@$chars) {
		$self->update($char, 'chars');
	}
}


1;
