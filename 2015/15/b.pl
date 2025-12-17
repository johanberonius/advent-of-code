#!/usr/bin/perl
use strict;

my @i;
while (<>) {
    my @l = /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/ or die $_;
    push @i => \@l;
}

my $m;
for my $i0 (0..100) {
    # my $i1 = 100-$i0;
    for my $i1 (0..100-$i0) {
        for my $i2 (0..100-$i0-$i1) {
            my $i3 = 100-$i0-$i1-$i2;

            next unless $i0 * $i[0][5] + $i1 * $i[1][5] + $i2 * $i[2][5] + $i3 * $i[3][5] == 500;

            my $p = 1;
            for my $i (1..4) {
                my $s = $i0 * $i[0][$i] + $i1 * $i[1][$i] + $i2 * $i[2][$i] + $i3 * $i[3][$i];
                $p *= $s > 0 ? $s : 0;
            }

            $m = $p if $m < $p;
        }
    }
}

print "Max: $m\n";
