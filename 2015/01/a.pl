#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %c = ('(' => 1, ')' => -1);
print sum map $c{$_}, split '', <>;
