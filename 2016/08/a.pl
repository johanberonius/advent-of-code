#!/usr/bin/perl
use strict;

my %g;
my ($w, $h) = (50, 6);

while (<>) {
    if (/rect (\d+)x(\d+)/) {
        for my $y (0..$2-1) {
            for my $x (0..$1-1) {
                $g{"$x,$y"}++;
            }
        }
    } elsif (/rotate row y=(\d+) by (\d+)/) {
        my $y = $1;
        for (1..$2) {
            my $t = $g{($w-1).",$y"};
            for my $x (reverse 0..$w-2) {
                $g{($x+1).",$y"} = $g{"$x,$y"};
            }
            $g{"0,$y"} = $t;
        }
    } elsif (/rotate column x=(\d+) by (\d+)/) {
        my $x = $1;
        for (1..$2) {
            my $t = $g{"$x,".($h-1)};
            for my $y (reverse 0..$h-2) {
                $g{"$x,".($y+1)} = $g{"$x,$y"};
            }
            $g{"$x,0"} = $t;
        }
    } else {
        die $_;
    }
}

my $p = grep $_, values %g;
print "Pixels: $p\n";
