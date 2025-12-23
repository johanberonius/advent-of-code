#!/usr/bin/perl
use strict;

while (<>) {
    chomp;
    print;
    print "\nLength: ", length, "\n";

    my $l = 0;
    while (s/^(.*?)\((\d+)x(\d+)\)//) {
        $l += length $1;
        $l += $2 * $3;
        s/.{$2}//;
    }
    $l += length;

    print "Decompressed length: $l\n";
    print "\n";
}
