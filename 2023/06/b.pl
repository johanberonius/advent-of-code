#!/usr/bin/perl
use strict;

my $t;
my $d;
while (<>) {
    $t = 0+join '', /\d+/g if /Time:/;
    $d = 0+join '', /\d+/g if /Distance:/;
}

print "Time: $t, distance: $d\n";

my $n = 0;
for my $h (0..$t) {
    $n++ if  $h * ($t - $h) > $d;
}

print "Number of ways to win: $n\n";
