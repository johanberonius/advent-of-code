#!/usr/bin/perl
use strict;

my $i = 0;

my @n = map 0+$_, <>;
print "Numbers: ", 0+@n, "\n";
for my $xi (0..$#n-2) {
    my $x = $n[$xi];
    for my $yi ($xi+1..$#n-1) {
        my $y = $n[$yi];
        for my $zi ($yi+1..$#n) {
            my $z = $n[$zi];
            $i++;
            if ($x + $y + $z == 2020) {
                print "$x + $y + $z == 2020, $x * $y * $z == ", $x * $y * $z, "\n";
            }
        }
    }
}

print "$i tests\n";
