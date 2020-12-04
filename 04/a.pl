#!/usr/bin/perl
use strict;

my @p = split /\s*\n\s*\n\s*/, join '', <>;

print "Number of passports: ", 0+@p, "\n";

my $v = 0;
for my $p (@p) {
    my %p = map { split ':' } split /\s+/, $p;

    $v++ if 7 == grep $_ ne 'cid', keys %p;
}

print "$v valid passports.\n";
