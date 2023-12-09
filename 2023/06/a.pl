#!/usr/bin/perl
use strict;

my @t;
my @d;
while (<>) {
    @t = map 0+$_, /\d+/g if /Time:/;
    @d = map 0+$_, /\d+/g if /Distance:/;
}

print "Times: @t\n";
print "Distances: @d\n";

my $p = 1;
while (@t) {
    my $t = shift @t;
    my $d = shift @d;

    print "Time: $t, distance: $d\n";

    my $n = 0;
    for my $h (0..$t) {
        $n++ if  $h * ($t - $h) > $d;
    }

    print "Number of ways to win: $n\n";
    $p *= $n;
}

print "Product: $p\n";
