#!/usr/bin/perl
use strict;

while (<>) {
    chomp;
    print;
    print "\nLength: ", length, "\n";
    my $l = decompress($_);
    print "Decompressed length: $l\n";
    print "\n";
}

sub decompress {
    my $s = shift;
    my $l = 0;
    my $o = $s;
    print "Decompress $s\n";

    while ($s =~ s/^(.*?)\((\d+)x(\d+)\)//) {
        $l += length $1;
        my $r = $3;
        $s =~ s/(.{$2})// or die $s;
        $l += decompress($1) * $r;
    }
    $l += length $s;
    print "Decompressed $o: $l\n";
    return $l;
}
