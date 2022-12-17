#!/usr/bin/perl
use strict;

my $c = 0;
my @b = ($c);
my $s = 348;
my $p = 0;

while (++$c <= 2017) {
    $p += $s;
    $b = $p % @b;
    splice @b, $b + 1, 0, $c;
    $p = $b + 1;
}

$b = ++$p % @b;
print "Value after final position: $b[$b]\n";
