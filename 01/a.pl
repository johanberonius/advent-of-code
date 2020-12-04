#!/usr/bin/perl
use strict;

my $i = 0;

my @n = map 0+$_, <>;
print "Numbers: ", 0+@n, "\n";
for my $xi (0..$#n-1) {
    my $x = $n[$xi];
    for my $yi ($xi+1..$#n) {
        my $y = $n[$yi];
        $i++;
        if ($x + $y == 2020) {
            print "$x + $y == 2020, $x * $y == ", $x * $y, "\n";
        }
    }
}

print "$i tests\n";
