#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my %g = map { chomp; $_ => '#' } <>;
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

my $c = 0;
my $i = 0;
my @q = [$xmin-1, $ymin-1, $zmin-1];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $z) = @$q;
    $i++;

    next if $g{"$x,$y,$z"};

    $g{"$x,$y,$z"} = '.';
    $c++;

    my ($b, $f) = ($z-1, $z+1);
    my ($n, $s) = ($y-1, $y+1);
    my ($w, $e) = ($x-1, $x+1);

    push @q => [$x, $y, $b] if !$g{"$x,$y,$b"} && $b >= $zmin-1;
    push @q => [$x, $y, $f] if !$g{"$x,$y,$f"} && $f <= $zmax+1;
    push @q => [$x, $n, $z] if !$g{"$x,$n,$z"} && $n >= $ymin-1;
    push @q => [$x, $s, $z] if !$g{"$x,$s,$z"} && $s <= $ymax+1;
    push @q => [$w, $y, $z] if !$g{"$w,$y,$z"} && $w >= $xmin-1;
    push @q => [$e, $y, $z] if !$g{"$e,$y,$z"} && $e <= $xmax+1;
}

print "Flood filled $c cubes after $i iterations.\n";

my $a = 0;
for my $z ($zmin..$zmax) {
    for my $y ($ymin..$ymax) {
        for my $x ($xmin..$xmax) {
            next unless $g{"$x,$y,$z"} eq '#';

            my ($b, $f) = ($z-1, $z+1);
            my ($n, $s) = ($y-1, $y+1);
            my ($w, $e) = ($x-1, $x+1);

            $a++ if $g{"$x,$y,$b"} eq '.';
            $a++ if $g{"$x,$y,$f"} eq '.';
            $a++ if $g{"$x,$n,$z"} eq '.';
            $a++ if $g{"$x,$s,$z"} eq '.';
            $a++ if $g{"$w,$y,$z"} eq '.';
            $a++ if $g{"$e,$y,$z"} eq '.';
        }
    }
}

print "Surface area: $a\n";
