#!/usr/bin/perl
use strict;

my @n = sort { $a <=> $b } map 0+$_, <>;
print "Number of joltage adapters: ", 0+@n, "\n";

push @n => $n[-1] + 3;
print "Device joltage: $n[-1]\n";

my %d;
my $p = 0;
for my $n (@n) {
    $d{$n - $p}++;
    $p = $n;
}

print "Step of 1: $d{1}, steps of 3: $d{3}, product: ", $d{1} * $d{3}, "\n";
