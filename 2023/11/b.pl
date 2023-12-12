#!/usr/bin/perl
use strict;
use List::Util qw(none);


my $f = 1_000_000;
my @g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    my $gx = 0;
    for my $e (split '') {
        if ($e eq '#') {
            push @g => [$x, $y];
            $gx++;
        }
        $x++;
    }
    $width = $x if $x > $width;
    unless ($gx) {
        print "No galaxies with y: $y\n";
        $y += $f;
    } else {
        $y++;
    }

}
$height = $y;

print "Grid width: $width, height: $height\n";


for (my $x = 0; $x < $width; $x++) {
    if (none { $_->[0] == $x } @g) {
        print "No galaxies with x: $x\n";
        for (@g) {
            $_->[0] += $f - 1 if $_->[0] > $x;
        }
        $x += $f - 1;
        $width += $f - 1;
    }

}

print "Grid width: $width, height: $height\n";

my $s = 0;
my $p = 0;
for my $i (0..$#g-1) {
    for my $j ($i+1..$#g) {
        my $d = abs($g[$i][0] - $g[$j][0]) + abs($g[$i][1] - $g[$j][1]);
        print "Distance from galaxy $i ($g[$i][0], $g[$i][1]) to $j ($g[$j][0], $g[$j][1]) : $d\n";
        $s += $d;
        $p++;
    }
}

print "Pairs: $p, total distance: $s\n";
