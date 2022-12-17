#!/usr/bin/perl
use strict;

# my $n = 119_315_717_514_047;
my $n = 10;

my $i = 101_741_582_076_661;


my @r = reverse <>;

for my $d (0..$n-1) {
    print "$d"
    my $c = 0;
    while (++$c <= 1) {
        for (@r) {
            # print;
            if (/new stack/) {
                $d = $n - 1 - $d;
            } elsif (/cut\s+(-?\d+)/) {
                my $i = 0+$1;
                if ($i < 0) {
                    $d -= $i;
                    $d += $n if $d < 0;
                } elsif ($i > 0) {
                    $d += $i;
                    $d -= $n if $d >= $n;
                } else {
                    die "Cut by zero";
                }
            } elsif (/increment\s+(\d+)/) {
                my $i = 0+$1;
                $d = ($d * $i) % $n;
            } else {
                die "Unrecognized rule: $_";
            }
        }
    }
    print " => $d\n";
}
