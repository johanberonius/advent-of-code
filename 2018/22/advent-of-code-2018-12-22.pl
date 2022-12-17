#!/usr/bin/perl
use strict;

my $depth =  7305;
my @target = (13, 734);

# my $depth =  510;
# my @target = (10, 10);
my $total_risk = 0; # 114;

my %geo;
my %erosion;
my %type;
for my $y (0..$target[1]) {
    for my $x (0..$target[0]) {
        my $p = "$x,$y";
        if ($y == 0) {
            $geo{$p} = $x * 16807;
        } elsif ($x == 0) {
            $geo{$p} = $y * 48271;
        } elsif ($x == $target[0] && $y == $target[1]) {
            $geo{$p} = 0;
        } else {
            $geo{$p} = $erosion{($x-1).",$y"} * $erosion{"$x,".($y-1)};
        }

        $erosion{$p} = ($geo{$p} + $depth) % 20183;
        $type{$p} = $erosion{$p} % 3;
        $total_risk += $type{$p};
    }
}

print "Total risk: $total_risk\n";