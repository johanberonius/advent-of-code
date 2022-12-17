#!/usr/bin/perl
use strict;

my $a = 277;
my $b = 349;
my $m = 0;
my $c = 40_000_000;
while ($c--) {
    $a *= 16807; $a %= 0x7FFF_FFFF;
    $b *= 48271; $b %= 0x7FFF_FFFF;
    $m += ($a & 0xFFFF) == ($b & 0xFFFF);
    print "$c\n" if $c % 1_000_000 == 0;
}

print "Matching pairs: $m\n";
