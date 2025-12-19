#!/usr/bin/perl
use strict;

my $n = 33_100_000;

my $h = 776_000;
my $p;

while (1) {
    $h++;

    $p = 0;
    for my $e (1..$h) {
        $p += 10 * $e * !($h % $e);
    }

    print "House $h got $p presents.\n" unless $h % 1_000;

    last if $p >= $n;
}

print "House $h got $p presents.\n";

# House 776160 (720_720 + 55_440) got 33611760 presents.
