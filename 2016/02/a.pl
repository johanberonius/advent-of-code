#!/usr/bin/perl
use strict;


my ($x, $y) = (1, 1);

while (<>) {
    chomp;
    my @d = split '';

    for my $d (@d) {
        $x-- if $d eq 'L' && $x > 0;
        $x++ if $d eq 'R' && $x < 2;
        $y-- if $d eq 'U' && $y > 0;
        $y++ if $d eq 'D' && $y < 2;
    }

    my $n = $y * 3 + $x + 1;
    print $n;
}

print "\n";
