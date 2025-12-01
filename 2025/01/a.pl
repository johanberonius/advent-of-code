#!/usr/bin/perl
use strict;

my $c = 0;
my $n = 50;

while(<>) {
    chomp;
    tr/LR/-+/;
    print "$n$_";
    $n += $_;
    $c++ unless $n % 100;
    print " = $n\n";
}

print "Points at zero $c times.\n";
