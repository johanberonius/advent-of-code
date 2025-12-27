#!/usr/bin/perl
use strict;

print "(declare-const t Int)\n";
print "(assert (>= t 0))\n";

my $i = 1;
while (<>) {
    my ($o1, $d, $o2) = /Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)\./ or die $_;
    my $o = $o1 + $o2;
    print "(assert (= 0 (mod (+ $o t) $d)))\n";
    $i++;
}

print "(assert (= 0 (mod (+ $i t) 11)))\n";

print "(minimize t)\n";
print "(check-sat)\n";
print "(get-value (t))\n";
