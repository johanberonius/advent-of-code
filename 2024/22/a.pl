#!/usr/bin/perl
use strict;

my @n = map 0+$_, <>;
my $s = 0;
for my $n (@n) {
    print "$n: ";
    for (1..2000) {
        $n ^= $n * 64;
        $n %= 16777216;

        $n ^= int $n / 32;
        $n %= 16777216;

        $n ^= $n * 2048;
        $n %= 16777216;
    }
    print "$n\n";
    $s += $n;
}

print "Sum: $s\n";
