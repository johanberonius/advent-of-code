#!/usr/bin/perl
use strict;

my @g = split /\s*\n\s*\n\s*/, join '', <>;

print "Number of groups: ", 0+@g, "\n";

my $s = 0;
for my $g (@g) {
    my @p = split /\s*\n\s*/, $g;
    my $p = 0+@p;
    print "Persons in group: $p\n";

    my %g;
    $g{$_}++ for split /\s*/, $g;

    my $q = 0 + grep $g{$_} == $p, keys %g;
    print "Common questions in group: $q\n";
    $s += $q;
}

print "Sum of common questions per group: $s\n";
