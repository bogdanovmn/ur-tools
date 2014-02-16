#!/usr/bin/env perl
use Dancer;
use UR;

sub Carp::shortmess_heavy {}
sub Carp::longmess_heavy {}

dance;
