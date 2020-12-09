#!/usr/bin/perl
use strict;

my @n;
my $l = 25;
my $c = 0;
while (<>) {
    my $n = 0+$_;
    $c++;

    if (@n == $l) {
        my $s = 0;
        sum: for my $i (0..$l-1) {
            for my $j ($i+1..$l) {
                if ($n[$i] + $n[$j] == $n) {
                    $s = 1;
                    last sum;
                }
            }
        }

        unless ($s) {
            print "$n at $c is not a sum of two of the previous $l numbers.\n";
            last;
        }

        shift @n;
    } elsif (@n > $l) {
        die "List overflow: ", 0+@n, "\n";
    }

    push @n => $n;
}
