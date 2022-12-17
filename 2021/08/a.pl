#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %l;
while (<>) {
    $l{length $_}++ for split /\s+/, (split /\|\s*/)[1];
}

print map "$_: $l{$_}\n", keys %l;

print "Number of 1, 4, 7 and 8: ", sum(@l{2, 3, 4, 7}), "\n";
