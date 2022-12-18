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

print "Shapes: ", 0+@shapes, "\n";
print "Directions: ", 0+@directions, "\n";

my $count = 0;
my $si = 0;
my $di = 0;
my @grid;
my $splicedHeight = 0;
my $spliceLength = 1_000;
my $maxDropDepth = 0;
my %seen;
my $targetCount = 1_000_000_000_000;
while (1) {
    $si = $count % @shapes;
    my @shape = @{$shapes[$si]};
    my $height = @shape;
    # print "Shape height: $height\n";

    if (@grid > $spliceLength + 100) {
        splice @grid, 0, $spliceLength;
        $splicedHeight += $spliceLength;
    }

    my $y = $#grid + 3 + $height;

    my $key = "$si,$di," . join ',', @grid[-3..-1];
    if ($seen{$key}) {
        my $cycleDiff = $count - $seen{$key}[0];
        my $heightDiff = $splicedHeight + @grid - $seen{$key}[1];
        print "Seen $key before at $seen{$key}[0] after $count. Cycle diff: $cycleDiff, height diff: $heightDiff\n";

        my $multiple = int(($targetCount - $count) / $cycleDiff);
        $count += $multiple * $cycleDiff;
        $splicedHeight += $multiple * $heightDiff;

        %seen = ();
        my $cyclesRemain = $targetCount - $count;
        print "Fast forward to cycle count $count and height: ", $splicedHeight+@grid, ", cycles remaining: $cyclesRemain\n";
    }
    $seen{$key} = [$count, $splicedHeight+@grid];

    if ($count >= $targetCount) {
        print "Iterations: $count\n";
        print "Height: ", $splicedHeight+@grid, "\n";
        print "Time: ", time() - $t1, "\n";
        last;
    }

    # print "Drop at $y\n";
    my $startHeight = $#grid;

    while (1) {
        my $direction = $directions[$di];
        $di = ++$di % @directions;
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

    my $dropDepth = $startHeight - $y;
    $maxDropDepth = $dropDepth if $maxDropDepth < $dropDepth;

    $count++;
}

print "Max drop depth: $maxDropDepth\n";

sub collides {
    my ($shape, $y) = @_;

    for my $row (@$shape) {
        return 1 if $row & $walls || $y < 0 || $row & $grid[$y];
        $y--;
    }
    return 0;
}
