#!/usr/bin/perl
use strict;
use Math::Utils qw(sign);

my $c = 0;
report: while (<>) {
    my @n = split ' ';
    print "@n";

    my $s = sign $n[1] - $n[0];
    for my $i (0..$#n-1) {
        my $d = ($n[$i+1] - $n[$i]) * $s;
        next report if $d < 1 || $d > 3;
    }
    $c++;
    print " - safe";
} continue {
    print "\n";
}

print "$c reports are safe.\n";
