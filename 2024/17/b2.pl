#!/usr/bin/perl
use strict;

for my $n (1..1_000_000_000) {
    my $A = $n;
    my $B = 0;
    my $C = 0;
    my $out = '';

    while ($A != 0) {
        $B = $A & 7;
        $B ^= 5;
        $C = $A >> $B;
        $B ^= 6;
        $A >>= 3;
        $B ^= $C;
        $out .= $B & 7;
    }

    print "Iteration: $n\n" unless $n % 1_000_000;

    if ($out eq '2415751603465530') {
        print "Output is equal to program for A: $n\n";
        last;
    }
}
