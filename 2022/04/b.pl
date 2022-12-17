#!/usr/bin/perl
use strict;

my $t = 0;
while (<>) {
    /(\d+)-(\d+),(\d+)-(\d+)/ or die "Unexpected pattern: $_";

    $t++ if $2 >= $3 && $1 <= $4;
}

print "Overlapping ranges: $t\n";
