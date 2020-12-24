#!/usr/bin/perl
use strict;

my %d = (
    e  => { x =>  1, y =>  0 },
    se => { x =>  1, y =>  1 },
    sw => { x =>  0, y =>  1 },
    w  => { x => -1, y =>  0 },
    nw => { x => -1, y => -1 },
    ne => { x =>  0, y => -1 },
);
my %t;
my $c = 0;
while (<>) {
    my @s = /(e|se|sw|w|nw|ne)/g;

    my ($x, $y) = (0, 0);
    for my $s (@s) {
        $x += $d{$s}{x};
        $y += $d{$s}{y};
    }

    $t{"$x,$y"} = !$t{"$x,$y"};
    $c++;
}

print "Flipped $c tiles\n";
print "Black tiles ", 0+grep($_, values %t), "\n";
