#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my @n = map 0+$_, <>;

# my $n = 127;
my $n = 466456641;

r: for my $i (0..$#n-1) {
    my $s = 0;
    for my $j ($i..$#n) {
        $s += $n[$j];
        last if $s > $n;
        if ($s == $n) {
            my $min = min(@n[$i..$j]);
            my $max = max(@n[$i..$j]);
            print "Found range from $i to $j that sums to $n. ";
            print "Min: $min, max: $max, sum: ", $min + $max, "\n";
            last r;
        }
    }
}
