#!/usr/bin/perl
use strict;

my %points = (
    # Move
    'X' => 1,
    'Y' => 2,
    'Z' => 3,
    # Win
    'A,Y' => 6,
    'B,Z' => 6,
    'C,X' => 6,
    # Draw
    'A,X' => 3,
    'B,Y' => 3,
    'C,Z' => 3,
);

my $t = 0;
while (<>) {
    my ($a, $b) = /(\w+)\s+(\w+)/;
    my $s = $points{$b} + $points{"$a,$b"};
    $t += $s;
    print "$a $b => $s\n";
}
print "Score: $t\n";
