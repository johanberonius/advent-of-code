#!/usr/bin/perl
use strict;

my $c = 0;
my $s = 348;
my $p = 0;
my $z;

while (++$c <= 50_000_000) {
    $p += $s;
    $b = $p % $c;
    $z = $c if $b == 0;
    $p = $b + 1;
}

print "Value inserted after zero: $z\n";
