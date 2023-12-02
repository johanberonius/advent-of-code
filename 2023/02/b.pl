#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $sum = 0;
while (<>) {
    my ($id) = /Game (\d+)/ or die "Unrecognized input: $_";

    my @red = /(\d+) red/g;
    my @green = /(\d+) green/g;
    my @blue = /(\d+) blue/g;

    my $power = max(@red) * max(@green) * max(@blue);

    print "Game $id power $power.\n";
    $sum += $power;
}

print "Sum: $sum\n";
