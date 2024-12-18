#!/usr/bin/perl
use strict;

my $n = 0o14424632;
my $md = 0;
n: while (1) {
    $n += 0o100000000;
    my $A = $n;
    my $B = 0;
    my $C = 0;

    my $d = 0;
    for my $o (2,4,1,5, 7,5,1,6, 0,3,4,6, 5,5,3,0) {
        $B = $A & 7;
        $B ^= 5;
        $C = $A >> $B;
        $B ^= 6;
        $B ^= $C;
        $A >>= 3;
        next n unless ($B & 7) == $o;

        $d++;
        if ($d > $md) {
            printf "Iteration: $n, %o, correct: $d\n", $n;
            $md = $d;
        }
    }

    print "Output is equal to program for A: $n\n";
    last;
}
