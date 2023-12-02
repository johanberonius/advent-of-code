#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $sum = 0;
while (<>) {
    my ($id) = /Game (\d+)/ or die "Unrecognized input: $_";

    my @red = /(\d+) red/g;
    if (max(@red) > 12) {
        print "Game $id is not possible, red: @red, max: ", max(@red), ".\n";
        next;
    }

    my @green = /(\d+) green/g;
    if (max(@green) > 13) {
        print "Game $id is not possible, green: @green, max: ", max(@green), ".\n";
        next;
    }

    my @blue = /(\d+) blue/g;
    if (max(@blue) > 14) {
        print "Game $id is not possible, blue: @blue, max: ", max(@blue), ".\n";
        next;
    }

    print "Game $id is possible, max red: ", max(@red), ", max blue: ", max(@blue), ", max green: ", max(@green), ".\n";
    $sum += $id;
}

print "Sum: $sum\n";
