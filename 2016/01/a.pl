#!/usr/bin/perl
use strict;

my @d = map { /([LR])(\d+)/ or die; [$1 => 0+$2] } split /,\s*/, <>;


my ($x, $y) = (0, 0);
my ($dx, $dy) = (0, -1);

print "Directions: ", 0+@d, "\n";
print "Start: $x x $y\n";

for my $d (@d) {
    if ($d->[0] eq 'R') {
        ($dx, $dy) = (-$dy, $dx);
    } elsif ($d->[0] eq 'L') {
        ($dx, $dy) = ($dy, -$dx);
    } else {
        die;
    }

    $x += $dx * $d->[1];
    $y += $dy * $d->[1];

    print "Direction: @$d, $dx x $dy,  \tPosition: $x x $y\n";
}

print "Destination: $x x $y\n";
print "Distance: ", abs $x + abs $y, "\n";
