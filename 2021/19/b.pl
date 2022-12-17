#!/usr/bin/perl
use strict;

my @p;
while (<>) {
    push @p => [0+$1, 0+$2, 0+$3] if /(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)/;
}

print "Scanners: ", 0+@p, "\n";

my $m;
for my $p1 (@p) {
    for my $p2 (@p) {
        my $d = abs($p2->[0] - $p1->[0]) +
                abs($p2->[1] - $p1->[1]) +
                abs($p2->[2] - $p1->[2]);

        $m = $d if $m < $d;
    }
}

print "Max distance: $m\n";