#!/usr/bin/perl
use strict;

my ($w, $h) = (0, 0);
my @r;
while (<>) {
    chomp;
    $w = 0;
    $r[$w++][$h] = 0+$_ for split '';
    $h++;
}

print "Grid, width: $w, height: $h\n";


my @p = ([0, 0, 0]);
my @m;
my $c = 0;
my $i = 0;
while (@p) {
    my ($x, $y, $r) = @{shift @p};
    $c++;

    next if $x < 0 || $x >= $w || $y < 0 || $y >= $h;

    next if $m[$x][$y] && $m[$x][$y] <= $r;

    $m[$x][$y] = $r;

    if ($x == $w-1 && $y == $h-1) {
        print "Risk at exit: $r\n";
        next;
    }

    $i++;

    push @p => (
        [$x, $y-1, $r+$r[$x][$y-1]],
        [$x+1, $y, $r+$r[$x+1][$y]],
        [$x, $y+1, $r+$r[$x][$y+1]],
        [$x-1, $y, $r+$r[$x-1][$y]],
    );
}

print "Minimum risk: $m[-1][-1]\n";
print "Evaluated $c positions and $i intermediate steps.\n";
