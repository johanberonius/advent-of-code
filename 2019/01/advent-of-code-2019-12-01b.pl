#!/usr/bin/perl
use strict;

my $f = 0;
while (my $a = <>) {
    while (1) {
        $a = int($a / 3) - 2;
        last if $a <= 0;
        $f += $a;
    }
}
print "Required total fuel: $f\n";
