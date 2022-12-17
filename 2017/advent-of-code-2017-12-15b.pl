#!/usr/bin/perl
use strict;

my $a = 277;
my $b = 349;
my $m = 0;
my $c = 5_000_000;
while ($c--) {
    do { $a *= 16807; $a %= 0x7FFF_FFFF; } while $a & 3;
    do { $b *= 48271; $b %= 0x7FFF_FFFF; } while $b & 7;
    $m += ($a & 0xFFFF) == ($b & 0xFFFF);
    print "$c\n" if $c % 1_000_000 == 0;
}

print "Matching pairs: $m\n";
