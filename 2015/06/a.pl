#!/usr/bin/perl
use strict;

my %g;
while (<>) {
    my ($i, $x1, $y1, $x2, $y2) = /(turn on|turn off|toggle) (\d+),(\d+) through (\d+),(\d+)/ or die $_;

    for my $y ($y1..$y2) {
        for my $x ($x1..$x2) {
            if ($i eq 'turn on') {
                $g{"$x,$y"} = 1;
            } elsif ($i eq 'turn off') {
                $g{"$x,$y"} = 0;
            } elsif ($i eq 'toggle') {
                $g{"$x,$y"} = !$g{"$x,$y"}
            } else {
                die $i;
            }
        }
    }
}

print "Lights: ", 0+grep($_, values %g), "\n";
