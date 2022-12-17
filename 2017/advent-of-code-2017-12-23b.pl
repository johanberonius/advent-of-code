#!/usr/bin/perl
use strict;

my $b = 105700;
my $c = 122700;
my $h = 0;
my $i = 0;
my $j = 0;

for (; $b <= $c; $b += 17, $j++) {
    for (my $d = 2; $d < sqrt $b; $d++, $i++) {
        ++$h and last if $b % $d == 0;
    }
}

print "Tested $j numbers in $i iterations, $h are not prime.\n";
