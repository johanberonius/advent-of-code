#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @m;
while (<>) {
    my ($x, $y, $z) = /x=(-?\d+)\D+y=(-?\d+)\D+z=(-?\d+)/;
    push @m => {
        p => { x => 0+$x, y => 0+$y, z => 0+$z},
        v => { x => 0, y => 0, z => 0},
    };
}

print "Scanned positions of ", 0+@m, " moons.\n";

my $t = 0;
while (1) {

    # Print
    unless ($t % 100) {
        print "After $t steps:\n";
        for my $i (0..$#m) {
            printf "pos=<x=%2d, y=%2d, z=%2d>, ", @{$m[$i]{p}}{qw(x y z)};
            printf "vel=<x=%2d, y=%2d, z=%2d>\n", @{$m[$i]{v}}{qw(x y z)};
        }
        print "\n";
    }

    last if $t >= 1000;

    # Update velocities with gravity (acceleration)
    for my $i (0..$#m) {
        for my $j (0..$#m) {
            next if $i == $j;
            for my $d (qw(x y z)) {
                $m[$i]{v}{$d} += $m[$j]{p}{$d} <=> $m[$i]{p}{$d};
            }
        }
    }

    # Update positions with velocities
    for my $i (0..$#m) {
        for my $d (qw(x y z)) {
            $m[$i]{p}{$d} += $m[$i]{v}{$d};
        }
    }

    $t++;
}


my $e = 0;
for my $i (0..$#m) {
    $e += (sum map abs, @{$m[$i]{p}}{qw(x y z)}) * (sum map abs, @{$m[$i]{v}}{qw(x y z)});
}
print "Total energy of system: $e\n";
