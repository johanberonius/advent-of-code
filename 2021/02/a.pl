#!/usr/bin/perl
use strict;

my $position = 0;
my $depth = 0;

while (<>) {
    my ($command, $value) = /(\w+)\s+(\d+)/;
    $position += $value if $command eq 'forward';
    $depth += $value if $command eq 'down';
    $depth -= $value if $command eq 'up';
    print "$command: $value, position: $position, depth: $depth\n";
}

print "product: ", $position * $depth, "\n";
