#!/usr/bin/perl
use strict;

my $f = 0;
$f += int((0+$_) / 3) - 2 while <>;
print "Required fuel: $f\n";
