#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my @j = grep $_, map { {'<' => -1, '>' => 1 }->{$_} } split '', <>;
my @s = (
    [
        ['#', '#', '#', '#'],
    ],
    [
        ['',  '#', ''],
        ['#', '#', '#'],
        ['',  '#', ''],
    ],
    [
        ['',  '',  '#'],
        ['',  '',  '#'],
        ['#', '#', '#'],
    ],
    [
        ['#'],
        ['#'],
        ['#'],
        ['#'],
    ],
    [
        ['#', '#'],
        ['#', '#'],
    ],
);

my $i = 0;
my $c = 0;
my %g = map { $_ .',-1' => '#' } 0..6;
while (1) {

    my $s = $s[$c++ % @s];
    my $sw = @{$s->[0]};
    my $sh = @{$s};
    # print "Shape width: $sw, height: $sh\n";

    my @y = map { (split ',')[1] } keys %g;
    my $ymax = max @y;
    my ($x, $y) = (2, $ymax + 3 + $sh);

    if ($c > 2022) {
        print "Height: ", $ymax+1, "\n";
        last;
    }

    # print "Drop at $x,$y\n";

    while (1) {
        my $j = $j[$i++ % @j];

        if (collides($s, $x+$j, $y)) {
            # print "Cant move side $j\n";
        } else {
            $x += $j;
            # print "Move side $j to $x\n";
        }

        if (collides($s, $x, $y-1)) {
            # print "Cant move down\n";
            plot($s, $x, $y);
            last;
        } else {
            $y--;
            # print "Move down to $y\n";
        }
    }
    # print "\n";
}

sub collides {
    my ($s, $px, $py) = @_;
    my $sw = @{$s->[0]};
    my $sh = @{$s};

    return 1 if $px < 0 || $px+$sw > 7;
    for my $y (0..$sh-1) {
        for my $x (0..$sw-1) {
            return 1 if $s->[$y][$x] && $g{($px+$x).','.($py-$y)};
        }
    }
    return 0;
}

sub plot {
    my ($s, $px, $py) = @_;
    my $sw = @{$s->[0]};
    my $sh = @{$s};

    # print "Plot shape at $px,$py w:$sw, h:$sh\n";

    for my $y (0..$sh-1) {
        for my $x (0..$sw-1) {
            $g{($px+$x).','.($py-$y)} ||= $s->[$y][$x];
        }
    }
}
