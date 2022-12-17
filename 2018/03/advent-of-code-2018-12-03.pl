#!/usr/bin/perl
use strict;

my ($c, %g);

while (<>) {
    $c++;
    my ($i, $x, $y, $w, $h) = /#(\d+)\s+@\s+(\d+),(\d+):\s+(\d+)x(\d+)/;

    for my $m ($y..$y+$h-1) {
        for my $n ($x..$x+$w-1) {
            $g{"$n,$m"}++;
        }
    }
}

my $d = grep $_ >= 2, values %g;

print "$c rectangles, overlap: $d\n";
