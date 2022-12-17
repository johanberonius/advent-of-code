#!/usr/bin/perl
use strict;
use POSIX;
use List::Util qw(sum);

my @n = sort { $a <=> $b } map 0+$_, split ',', <>;

print "Number of crab submarines: ", 0+@n, "\n";
print "Horizontal positions: ", join(',', @n), "\n";
my $p = sum(@n[int($#n/2), ceil($#n/2)]) / 2;
print "Median position: $p\n";
my $f = sum map abs $_-$p, @n;
print "Lowest fuel consumption at position $p is $f\n";
