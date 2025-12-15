#!/usr/bin/perl
use strict;

my $n = 0;
while (<>) {
    chomp;
    $n++ if /([aeiou].*){3}/ && /(\w)\1/ && !/ab|cd|pq|xy/;
}

print "Nice: $n\n";
