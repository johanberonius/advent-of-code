#!/usr/bin/perl
use strict;
use List::Util qw(reduce min max);

my %d = (0 => 4, 1 => 2, 2 => 3, 4 => 4, 6 => 6, 8 => 5, 10 => 6, 12 => 6, 14 => 6, 16 => 12, 18 => 8, 20 => 9, 22 => 8, 24 => 8, 26 => 8, 28 => 8, 30 => 12, 32 => 10, 34 => 8, 36 => 12, 38 => 10, 40 => 12, 42 => 12, 44 => 12, 46 => 12, 48 => 12, 50 => 14, 52 => 14, 54 => 12, 56 => 12, 58 => 14, 60 => 14, 62 => 14, 66 => 14, 68 => 14, 70 => 14, 72 => 14, 74 => 14, 78 => 18, 80 => 14, 82 => 14, 88 => 18, 92 => 17);
my @d = sort { $a <=> $b } keys %d;
my $m = max @d;
my $p = 0;
my %p;
my %i;
my %w;
my $n = 0;

while ($n < $m) {
    $w{$p++} = -1;

    for my $w (keys %w) {
        $w{$w}++;
        delete $w{$w} if $d{$w{$w}} && $p{$w{$w}} == 0;
    }
    $n = max values %w;

    for my $d (@d) {
        $p{$d} += $i{$d} ||= 1;
        $i{$d} = 1 if $p{$d} == 0;
        $i{$d} = -1 if $p{$d} == $d{$d} - 1;
    }

    print "Cycles: $p, length: ", 0+keys %w, ", max pos: $n, low delay: ", min(keys %w), "\n" if $p % 100_000 == 0;
}

print "Cycles: $p\n";
print "Number of layers: ", 0+@d, "\n";
print "Max layer depth: $m\n";
print "Lowest delay: ", min(keys %w), "\n";
