#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my %g = map { chomp; $_ => 1 } <>;
my @x = map { (split ',')[0] } keys %g;
my @y = map { (split ',')[1] } keys %g;
my @z = map { (split ',')[2] } keys %g;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;
my $zmin = min @z;
my $zmax = max @z;

my $width = $xmax - $xmin + 1;
my $height = $ymax - $ymin + 1;
my $depth = $zmax - $zmin + 1;

my $cubes = keys %g;
my $volume = $width * $height * $depth;

print "Grid width: $width, height: $height, depth: $depth, cubes: $cubes, volume: $volume\n";

my $a = 0;
for my $z ($zmin..$zmax) {
    for my $y ($ymin..$ymax) {
        for my $x ($xmin..$xmax) {
            next unless $g{"$x,$y,$z"};

            my ($b, $f) = ($z-1, $z+1);
            my ($n, $s) = ($y-1, $y+1);
            my ($w, $e) = ($x-1, $x+1);

            $a++ unless $g{"$x,$y,$f"};
            $a++ unless $g{"$x,$y,$b"};
            $a++ unless $g{"$x,$n,$z"};
            $a++ unless $g{"$x,$s,$z"};
            $a++ unless $g{"$w,$y,$z"};
            $a++ unless $g{"$e,$y,$z"};
        }
    }
}

print "Surface area: $a\n";
