#!/usr/bin/perl
use strict;

my @l = map 0+$_, <>;
my $s = 0;
my $p = 0;

while (++$s) {
    my $n = $p + $l[$p];
    $l[$p]++;
    $p = $n;
    last if $p < 0 || $p >= @l;
}

print "$s steps.\n";
