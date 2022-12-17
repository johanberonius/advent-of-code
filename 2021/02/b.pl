#!/usr/bin/perl
use strict;

my $position = 0;
my $depth = 0;
my $aim = 0;

while (<>) {
    my ($command, $value) = /(\w+)\s+(\d+)/;
    if ($command eq 'forward') {
        $position += $value;
        $depth += $aim * $value;
    }
    $aim += $value if $command eq 'down';
    $aim -= $value if $command eq 'up';
    print "$command: $value, position: $position, depth: $depth\n";
}

print "product: ", $position * $depth, "\n";
