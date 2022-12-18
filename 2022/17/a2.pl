#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Time::HiRes qw(time);
my $t1 = time();

my @directions = grep $_, map { {'<' => -1, '>' => 1 }->{$_} } split '', <>;
my @shapes = (
    [
        0b_00_11__11_00,
    ],
    [
        0b_00_01__00_00,
        0b_00_11__10_00,
        0b_00_01__00_00,
    ],
    [
        0b_00_00__10_00,
        0b_00_00__10_00,
        0b_00_11__10_00,
    ],
    [
        0b_00_10__00_00,
        0b_00_10__00_00,
        0b_00_10__00_00,
        0b_00_10__00_00,
    ],
    [
        0b_00_11__00_00,
        0b_00_11__00_00,
    ],
);
my $walls = 0b_1_00_00__00_01;


my $i = 0;
my $c = 0;
my @grid;
while (1) {
    my @shape = @{$shapes[$c++ % @shapes]};
    my $height = @shape;
    # print "Shape height: $height\n";

    my $y = $#grid + 3 + $height;

    if ($c > 2022) {
        print "Height: ", 0+@grid, "\n";
        print "Time: ", time() - $t1, "\n";
        last;
    }

    # print "Drop at $y\n";

    while (1) {
        my $direction = $directions[$i++ % @directions];
        my @moved = map $_ >> $direction, @shape;

        if (collides(\@moved, $y)) {
            # print "Cant move side $direction\n";
        } else {
            @shape = @moved;;
            # print "Move side $direction\n";
        }

        if (collides(\@shape, $y-1)) {
            # print "Cant move down\n";
            # print "Plot shape at $y\n";
            $grid[$y--] |= $_ for @shape;
            last;
        } else {
            $y--;
            # print "Move down to $y\n";
        }
    }
    # print "\n";
}

sub collides {
    my ($shape, $y) = @_;

    for my $row (@$shape) {
        return 1 if $row & $walls || $y < 0 || $row & $grid[$y];
        $y--;
    }
    return 0;
}

# Körtid fösta lösningen 3.0 s.
# Körtid bitwise operations 0.022 s. ~150x speed.
