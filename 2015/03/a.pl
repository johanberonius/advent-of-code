#!/usr/bin/perl
use strict;

my ($x, $y) = (0, 0);
my %g = ("$x,$y" => 1);
for (split '', <>) {
    $x++ if $_ eq '>';
    $x-- if $_ eq '<';
    $y++ if $_ eq 'v';
    $y-- if $_ eq '^';
    $g{"$x,$y"}++;
}

print "Houses: ", 0+values %g, "\n";
