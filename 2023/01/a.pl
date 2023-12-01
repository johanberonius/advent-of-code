#!/usr/bin/perl
use strict;

my $s = 0;
while (<>) {
    chomp;
    my @n = grep $_, map 0+$_, split '';
    print "$n[0]$n[-1]\n";
    $s += $n[0] * 10 + $n[-1];
}

print "Sum: $s\n";
