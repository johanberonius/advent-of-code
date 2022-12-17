#!/usr/bin/perl
use strict;
use List::Util qw(sum reduce);

sub h {
    my @v = (0 .. 255);
    my @l = map ord, split '', shift;
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

    map { reduce {$a ^ $b} @v[$_*16 .. $_*16+15] } 0 .. 15;
}

my $u = 0;
$u += sum split '', sprintf '%8.8b'x16, h("ljoxqyyw-$_") for (0..127);

print "Used squares: $u\n;"
