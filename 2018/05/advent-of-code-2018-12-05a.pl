#!/usr/bin/perl
use strict;

my @a = split '', <>;
my $c;

for (my $i; $i < $#a; $i++) {
    $c++;
    if ($a[$i] ne $a[$i+1] and lc $a[$i] eq lc $a[$i+1]) {
        print "Removing $a[$i]$a[$i+1] at $i\n";
        splice @a, $i, 2;
        $i-- if $i;
        redo;
    }
}

print "After $c iterations, remaining length ", 0+@a, "\n";
