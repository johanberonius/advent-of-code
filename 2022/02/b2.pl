#!/usr/bin/perl
use strict;

my %points = (
    # Lose
    'A,X' => 3,
    'B,X' => 1,
    'C,X' => 2,
    # Draw
    'A,Y' => 1 + 3,
    'B,Y' => 2 + 3,
    'C,Y' => 3 + 3,
    # Win
    'A,Z' => 2 + 6,
    'B,Z' => 3 + 6,
    'C,Z' => 1 + 6,
);

my $t = 0;
while (<>) {
    my ($a, $b) = /(\w+)\s+(\w+)/;
    my $s = $points{$b} + $points{"$a,$b"};
    $t += $s;
    print "$a $b => $s\n";
}
print "Score: $t\n";
