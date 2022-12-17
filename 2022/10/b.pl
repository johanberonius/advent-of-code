#!/usr/bin/perl
use strict;
use Term::ANSIColor;


my $x = 1;
my $c = 0;

while (<>) {
    /(\w+)(?:\s+(-?\d+))?/ or die "Unrecognized input: $_";
    draw();
    $c++;

    if ($1 eq 'noop') {

    } elsif ($1 eq 'addx') {
        draw();
        $c++;
        $x += $2;
    } else {
        die "Unrecognized instruction: $1\n";
    }

}

sub draw {
    # print "(", $c % 40, ",$x)";
    print abs($x - $c % 40) <= 1 ? (color('white', 'on_black'), '#') : (color('reset'), '.');
    print color('reset'), "\n" unless ($c+1) % 40;
}
