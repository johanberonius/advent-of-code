#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my @d = map { /([LR])(\d+)/ or die; [$1 => 0+$2] } split /,\s*/, <>;


my ($x, $y) = (0, 0);
my ($dx, $dy) = (0, -1);
my %v = ("$x,$y" => 1);

print "Directions: ", 0+@d, "\n";
print "Start: $x x $y\n";

d: for my $d (@d) {

    if ($d->[0] eq 'R') {
        ($dx, $dy) = (-$dy, $dx);
    } elsif ($d->[0] eq 'L') {
        ($dx, $dy) = ($dy, -$dx);
    } else {
        die;
    }

    for (1..$d->[1]) {
        $x += $dx;
        $y += $dy;
        if ($v{"$x,$y"}++) {
            print "Visited before: $x x $y\n";
            print "Distance: ", abs $x + abs $y, "\n";
            last d;
        }
    }

    print "Direction: @$d, $dx x $dy,  \tPosition: $x x $y\n";
}
