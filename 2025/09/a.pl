#!/usr/bin/perl
use strict;

my @p = map [/(\d+)/g], <>;
print "Points: ", 0+@p, "\n";

my $max;
my $i;
for my $p1 (@p) {
    my ($p1x, $p1y) = @$p1;
    for my $p2 (@p) {
        next if $p1 == $p2;
        my ($p2x, $p2y) = @$p2;
        $i++;
        my $dx = abs($p2x - $p1x) + 1;
        my $dy = abs($p2y - $p1y) + 1;
        my $a = $dx * $dy;
        $max = $a if $max < $a;
    }
}

print "Iterations: $i\n";
print "Max area: $max\n";
