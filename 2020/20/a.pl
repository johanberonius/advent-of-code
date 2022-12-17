#!/usr/bin/perl
use strict;
use List::Util qw(min max all product);

my ($x, $y) = (0, 0);
my $i;
my %c;
while (<>) {
    chomp;

    if (/Tile\s*(\d+)/i) {
        $i = 0+$1;
        $y = 0;
    } elsif ($i and $_) {
        $c{$i}{$x++ . ',' . $y} = $_ for split '';
        $y++;
        $x = 0;
    }
}

my $t = 0+keys %c;
my $g = sqrt $t;
my @x = map [split ',']->[0], keys %{$c{$i}};
my @y = map [split ',']->[1], keys %{$c{$i}};
my ($xmin, $xmax) = (min(@x), max(@x));
my ($ymin, $ymax) = (min(@y), max(@y));
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
print "Tiles: $t\n";
print "Tile width: $w\n";
print "Tile height: $h\n";
print "Tile size: ", $w * $h, "\n";
print "Grid size: $g x $g\n";


my $te = [map "$_,$ymin", $xmin..$xmax];
my $be = [map "$_,$ymax", $xmin..$xmax];
my $le = [map "$xmin,$_", $ymin..$ymax];
my $re = [map "$xmax,$_", $ymin..$ymax];
my $tr = [reverse @$te];
my $br = [reverse @$be];
my $lr = [reverse @$le];
my $rr = [reverse @$re];

my %m;
for my $i (keys %c) {
    edge: for my $d ($te, $be, $le, $re) {
        my @d = @{$c{$i}}{@$d};

        for my $j (keys %c) {
            next if $i == $j;
            for my $e ($te, $be, $le, $re, $tr, $br, $lr, $rr) {
                my @e = @{$c{$j}}{@$e};

                if (all { $d[$_] eq $e[$_] } 0..$#e) {
                    $m{$i}++;
                    next edge;
                }
            }
        }
    }
}

my @c = grep $m{$_} == 2, keys %m;
print "Corner ids: @c, product: ", product(@c), "\n";
