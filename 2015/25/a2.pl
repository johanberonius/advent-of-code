#!/usr/bin/perl
use strict;

my $n = 18331560;
my $s = 20151125;

for (2..$n) {
    $s *= 252533;
    $s %= 33554393;
}

print "$n: $s\n";
