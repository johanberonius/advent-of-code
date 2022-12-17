#!/usr/bin/perl
use strict;
use List::Util qw(min max);

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

my $i = 0;
while (1) {
    my @x = map [split ',']->[0], keys %t;
    my @y = map [split ',']->[1], keys %t;
    my ($xmin, $xmax) = (min(@x), max(@x));
    my ($ymin, $ymax) = (min(@y), max(@y));
    my $w = $xmax - $xmin + 1;
    my $h = $ymax - $ymin + 1;

    print "Day $i: ", 0+grep($_, values %t), "\n";

    last if ++$i > 100;

    my %u;
    for my $py ($ymin-1 .. $ymax+1) {
        for my $px ($xmin-1 .. $xmax+1) {
            my $xy = "$px,$py";
            my $t = $t{$xy};

            my $n = 0;
            for my $d (values %d) {
                $n += $t{($px+$d->{x}) . ',' . ($py+$d->{y})};
            }

            if ($t and $n == 0 || $n > 2) {
                $u{$xy} = !$t;
            } elsif (!$t and $n == 2) {
                $u{$xy} = !$t;
            } else {
                $u{$xy} = $t;
            }
        }
    }
    %t = %u;
}
