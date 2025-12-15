#!/usr/bin/perl
use strict;

my ($x1, $y1) = (0, 0);
my ($x2, $y2) = (0, 0);
my %g = ("$x1,$y1" => 2);
my @d = split '', <>;
while (@d) {
    my $d = shift @d;
    $x1++ if $d eq '>';
    $x1-- if $d eq '<';
    $y1++ if $d eq 'v';
    $y1-- if $d eq '^';
    $g{"$x1,$y1"}++;

    $d = shift @d;
    $x2++ if $d eq '>';
    $x2-- if $d eq '<';
    $y2++ if $d eq 'v';
    $y2-- if $d eq '^';
    $g{"$x2,$y2"}++;
}

print "Houses: ", 0+values %g, "\n";
