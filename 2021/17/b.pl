#!/usr/bin/perl
use strict;

my ($xmin, $xmax, $ymin, $ymax) = <> =~ /x=(-?\d+)..(-?\d+).+y=(-?\d+)..(-?\d+)/;

print "xmin: $xmin, xmax: $xmax, ymin: $ymin, ymax: $ymax\n";

my $t = 0;
my $s = 0;
my $n = 0;
for my $ivy ($ymin..-$ymin) {
    for my $ivx (1..$xmax) {
        my ($x, $y) = (0, 0);
        my ($vx, $vy) = ($ivx, $ivy);
        $t++;

        while (1) {
            $x += $vx;
            $y += $vy;
            $vx-- if $vx > 0;
            $vy--;
            $s++;

            last if $x > $xmax;
            last if $y < $ymin;
            next if $x < $xmin;
            next if $y > $ymax;

            $n++;
            last;
        }
    }
}

print "Checked $t, trajectories, total $s steps, hits: $n\n";
