#!/usr/bin/perl
use strict;


my $x = 1;
my $c = 0;
my $s = 0;

while (<>) {
    /(\w+)(?:\s+(-?\d+))?/ or die "Unrecognized input: $_";
    $c++;
    cx();

    if ($1 eq 'noop') {

    } elsif ($1 eq 'addx') {
        $c++;
        cx();
        $x += $2;
    } else {
        die "Unrecognized instruction: $1\n";
    }

}

sub cx {
    if (($c+20) % 40 == 0) {
        print "${c}th cycle, register X is $x, signal strength ", $c * $x, "\n";
        $s += $c * $x;
    }
}

print "Sum of signal strengths: $s\n";
