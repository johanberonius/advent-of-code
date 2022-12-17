#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $p = 1;
my $m = 1;
my @c = (0);
my $c = 0;
my %s;

while ($m <= 71250) {

    unless ($m % 23) {
        $s{$p} += $m;
        $c = ($c - 7) % @c;
        $s{$p} += splice @c, $c, 1;
    } else {
        $c = ($c + 2) % @c;
        splice @c, $c, 0, $m;
    }

    # print "[$p] ", join(' ', map($_ == $c ? "($c[$_])" : $c[$_], 0..$#c)), " \n";

    $p++;
    $p = 1 if $p > 452;
    $m++;
}

print "Highest score: ", max(values %s), "\n";
