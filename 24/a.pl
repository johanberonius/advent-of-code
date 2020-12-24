#!/usr/bin/perl
use strict;

my %d = (
    e  => { x =>  1, y =>  0, z =>  1},
    se => { x =>  1, y =>  1, z =>  0},
    sw => { x =>  0, y =>  1, z =>  1},
    w  => { x => -1, y =>  0, z => -1},
    nw => { x => -1, y => -1, z =>  0},
    ne => { x =>  0, y => -1, z => -1},
);
my %t;
my $c = 0;
while (<>) {
    my @s = /(e|se|sw|w|nw|ne)/g;

    my ($x, $y, $z) = (0, 0, 0);
    for my $s (@s) {
        $x += $d{$s}{x};
        $y += $d{$s}{y};
        $z += $d{$s}{z};
    }

    $t{"$x,$y"} = !$t{"$x,$y"};
    $c++;
}

print "Flipped $c tiles\n";
print "Black tiles ", 0+grep($_, values %t), "\n";
