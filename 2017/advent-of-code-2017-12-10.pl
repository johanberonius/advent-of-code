#!/usr/bin/perl
use strict;

my @v = (0 .. 255);
my @l = (183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88);
my $p = 0;
my $s = 0;

for my $l (@l) {
    my @r = map $_ % 256, $p .. $p + $l - 1;
    @v[@r] = reverse @v[@r];
    $p += $l + $s++;
}

print "List, length ", scalar @v,": ", join(', ', @v), "\n";
print "Result: ", $v[0] * $v[1], "\n";
