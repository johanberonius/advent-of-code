#!/usr/bin/perl
use strict;

my $n = 0;
while (<>) {
    chomp;
    $n++ if /(\w\w).*\1/ && /(\w)\w\1/;
    print "$_ $n\n";
}

print "Nice: $n\n";
