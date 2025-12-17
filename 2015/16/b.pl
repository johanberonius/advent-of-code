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

    my @ct = grep /cats|trees/, keys %t;
    my @pg = grep /pomeranians|goldfish/, keys %t;
    my @o = grep !/cats|trees|pomeranians|goldfish/, keys %t;

    if (all { $d{$_} < $t{$_} } @ct and
        all { $d{$_} > $t{$_} } @pg and
        all { $d{$_} == $t{$_} } @o) {
        print "Matching Sue $n\n";
    }
}
