#!/usr/bin/perl
use strict;

my $sum = 0;
row: while (<>) {
    chomp;
    for my $m (reverse 1..9) {
        for my $n (reverse 1..9) {
            if (/$m.*$n/) {
                print "$_: $m$n\n";
                $sum += "$m$n";
                next row;
            }
        }
    }
}

print "Total output joltage: $sum\n";
