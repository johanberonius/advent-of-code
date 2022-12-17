#!/usr/bin/perl
use strict;

my @n;
push @n => 0+$_ while <>;

my $f = 0;
my $n = 0;
my %s;

print "List length: ", 0+@n, "\n";

while (1) {
    if ($s{$f}) {
       print "First frequency reached twice after $n interations: $f\n";
       last;
    }

    $s{$f}++;
    $f += $n[$n++ % @n]
}
