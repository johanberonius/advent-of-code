#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Math::Utils qw(sign);

my %p;
while (<>) {
    my ($x1, $y1, $x2, $y2) = /(\d+),(\d+)\s*->\s*(\d+),(\d+)/;
    my ($xmin, $xmax) = (min($x1, $x2), max($x1, $x2));
    my ($ymin, $ymax) = (min($y1, $y2), max($y1, $y2));
    my ($dx, $dy) = ($x2-$x1, $y2-$y1);

    if ($x1 == $x2) {
        print "Vertical line: $x1, $y1 -> $x2, $y2\n";
        $p{"$x1,$_"}++ for $ymin..$ymax;
    } elsif ($y1 == $y2) {
        print "Horizontal line: $x1, $y1 -> $x2, $y2\n";
        $p{"$_,$y1"}++ for $xmin..$xmax;
    } elsif (abs $dx == abs $dy) {
        print "Diagonal line: $x1, $y1 -> $x2, $y2\n";
        $p{($x1+$_*sign($dx)) .','. ($y1+$_*sign($dy))}++ for 0..abs($dx);
    } else {
        die "Unexpected line: $x1, $y1 -> $x2, $y2\n";
    }
}

my $c = grep $_ > 1, values %p;
print "Points with overlapping lines: $c\n";
