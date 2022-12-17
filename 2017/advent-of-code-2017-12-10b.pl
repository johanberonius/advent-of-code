#!/usr/bin/perl
use strict;
use List::Util qw(reduce);

my @v = (0 .. 255);
my @l = map ord, split '', '183,0,31,146,254,240,223,150,2,206,161,1,255,232,199,88';
push @l => (17, 31, 73, 47, 23);
my $p = 0;
my $s = 0;

for (1..64) {
    for my $l (@l) {
        my @r = map $_ % 256, $p .. $p + $l - 1;
        @v[@r] = reverse @v[@r];
        $p += $l + $s++;
    }
}

my @d = map { reduce {$a ^ $b} @v[$_*16 .. $_*16+15] } 0 .. 15;

print "Dense hash: ", join(', ', @d), "\n";
print "Dense hash hex: ", sprintf("%2.2x"x16, @d), "\n";
