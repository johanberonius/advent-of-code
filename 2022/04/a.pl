#!/usr/bin/perl
use strict;

my $t = 0;
while (<>) {
    /(\d+)-(\d+),(\d+)-(\d+)/ or die "Unexpected pattern: $_";

    $t++ if $1 >= $3 && $2 <= $4 ||
            $1 <= $3 && $2 >= $4;
}

print "Overlapping ranges: $t\n";
