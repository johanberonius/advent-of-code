#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %p = map { /(\w+)\)(\w+)/; $2 => $1 } <>;
my %d;

for my $k (keys %p) {
    my $d = 0;
    my $p = $k;
    $d++ while $p = $p{$p};
    $d{$k} = $d;
}

print "Total number of direct and indirect orbits: ", sum(values %d), "\n";
