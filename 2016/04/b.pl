#!/usr/bin/perl
use strict;

while (<>) {
    my ($n, $i, $c) = /([a-z-]+)-(\d+)\[([a-z]{5})\]/ or die $_;

    $n =~ tr/abcdefghijklmnopqrstuvwxyz/bcdefghijklmnopqrstuvwxyza/ for 1..$i;
    print "$n: $i\n";
}
