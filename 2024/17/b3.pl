#!/usr/bin/perl
use strict;

for my $n (1..1_000_000) {
    my $A = $n;
    my $B = 0;
    my $C = 0;
    my $out = '';

    while ($A != 0) {
        $A >>= 3;
        $out .= $A & 7;
    }

    if ($out eq '035430') {
        print "Output is equal to program for A: $n\n";
        last;
    }
}

# 0o345300
