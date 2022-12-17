#!/usr/bin/perl
use strict;

my %move = (
    # Lose
    'A,X' => 'Z',
    'B,X' => 'X',
    'C,X' => 'Y',
    # Draw
    'A,Y' => 'X',
    'B,Y' => 'Y',
    'C,Y' => 'Z',
    # Win
    'A,Z' => 'Y',
    'B,Z' => 'Z',
    'C,Z' => 'X',
);

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
    my $m = $move{"$a,$b"};
    my $s = $points{$m} + $points{"$a,$m"};
    $t += $s;
    print "$a $b $m => $s\n";
}
print "Score: $t\n";
