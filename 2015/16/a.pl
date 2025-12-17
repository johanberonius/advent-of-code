#!/usr/bin/perl
use strict;
use List::Util qw(all);

my %d = (
    children => 3,
    cats => 7,
    samoyeds => 2,
    pomeranians => 3,
    akitas => 0,
    vizslas => 0,
    goldfish => 5,
    trees => 3,
    cars => 2,
    perfumes => 1,
);

while (<>) {
    my ($n, $r) = /Sue (\d+): (.+)/ or die $_;
    my %t = split /: |, /, $r;

    if (all { $d{$_} == $t{$_} } keys %t) {
        print "Matching Sue $n\n";
    }
}
