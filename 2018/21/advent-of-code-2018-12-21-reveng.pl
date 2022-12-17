#!/usr/bin/perl
use strict;

die "Bitwise AND should be numeric" unless (123 & 456) == 72;


my $r = 10504829;
my $x;
my $y;
do {
    $y = $x | 65536;
    $x = 10649702;

    while () {
        $x += $y & 255;
        $x &= 0xFF_FFFF;
        $x *= 65899;
        $x &= 0xFF_FFFF;

        last if $y < 256;

        my $i = 0;
        $i++ until ($i + 1) * 256 > $y;
        $y = $i;
    }
} until ($x == $r);

print "$r\n";
