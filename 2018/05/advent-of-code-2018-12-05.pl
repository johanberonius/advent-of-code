#!/usr/bin/perl
use strict;

my @a = split '', <>;
my $c;
loop: while (1) {

    for my $i (0..$#a-1) {
        $c++;
        if ($a[$i] ne $a[$i+1] and lc $a[$i] eq lc $a[$i+1]) {
            # print "Removing $a[$i]$a[$i+1] at $i\n";
            splice @a, $i, 2;
            next loop;
        }
    }
    last;
}

print "After $c iterations, remaining length ", 0+@a, "\n";
