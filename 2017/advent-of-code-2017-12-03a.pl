#!/usr/bin/perl
use strict;

my $i = 325489;
my $c = 1;
my $r = 0;

while (1) {
    my $s = 8 * $r;
    last if $c + $s > $i;
    $c += $s;
    $r++;
}

print "$c $r\n";

my $stepsToGo = $i - $c;

my $maxSteps = 2 * $r;
my $steps = $maxSteps;
my $dir = -1;

while ($stepsToGo--) {

    if ($steps == $r) {
        $dir = 1;
    } elsif ($steps == $maxSteps) {
        $dir = -1;
    }

    $steps += $dir;
}

print "$steps\n";
