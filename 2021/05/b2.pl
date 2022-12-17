#!/usr/bin/perl
use strict;
use List::Util qw(max);

my %p;
while (<>) {
    my ($x1, $y1, $x2, $y2) = /(\d+),(\d+)\s*->\s*(\d+),(\d+)/;
    my ($dx, $dy) = ($x2-$x1, $y2-$y1);
    my $dmax = max(abs $dx, abs $dy);

    print "Line: $x1, $y1 -> $x2, $y2\n";
    $p{($x1+$dx*$_/$dmax) .','. ($y1+$dy*$_/$dmax)}++ for 0..$dmax;
}

my $c = grep $_ > 1, values %p;
print "Points with overlapping lines: $c\n";
