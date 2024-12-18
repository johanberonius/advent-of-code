#!/usr/bin/perl
use strict;

my $n = 136904921196954;
n: while (1) {
    $n--;
    my $A = $n;
    my $B = 0;
    my $C = 0;

    printf "Iteration: $n\n" unless $n % 1_000_000;

    for my $o (2,4,1,5, 7,5,1,6, 0,3,4,6, 5,5,3,0) {
        $B = $A & 7;
        $B ^= 5;
        $C = $A >> $B;
        $B ^= 6;
        $B ^= $C;
        $A >>= 3;
        next n unless ($B & 7) == $o;
    }

    print "Output is equal to program for A: $n\n";
    # last;
}
