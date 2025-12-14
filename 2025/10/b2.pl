#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $s = 0;
while (<>) {
    print;
    chomp;

    my $o = `./z3.pl '$_' | node z3.mjs`;
    my ($n) = $o =~ /\(m\s+(\d+)\)/;

    print "Button presses: $n\n";
    $s += $n;
}

print "Sum of minimum button presses: $s\n";
