#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my %grid;
my ($x, $y) = (0, 0);

while (<>) {
    chomp;
    last unless $_;
    $x = 0;
    for my $e (split '') {
        $grid{"$x,$y"} = $e if $e eq '#';
        $x++;
    }
    $y++;
}

my @dir = (
    [(-1, -1), (0, -1), (1, -1)],
    [(-1,  1), (0,  1), (1,  1)],
    [(-1, -1), (-1,  0), (-1,  1)],
    [( 1, -1), ( 1,  0), ( 1,  1)],
);

my $c = 0;
draw();

while ($c < 10) {
    my %moves;

    for my $key (keys %grid) {
        my ($x, $y) = split ',', $key;
        my ($n, $s) = ($y-1, $y+1);
        my ($w, $e) = ($x-1, $x+1);

        my $adjacent = grep $grid{$_}, (
            "$w,$n", "$x,$n", "$e,$n",
            "$w,$y",        , "$e,$y",
            "$w,$s", "$x,$s", "$e,$s",
        );

        if (!$adjacent) {
            push @{$moves{"$x,$y"}} => "$x,$y";
        } else {
            my $moved = 0;
            for my $dir (@dir) {
                my (($m1x, $m1y), ($m2x, $m2y), ($m3x, $m3y)) = @$dir;
                if (!$grid{($x+$m1x).','.($y+$m1y)} && !$grid{($x+$m2x).','.($y+$m2y)} && !$grid{($x+$m3x).','.($y+$m3y)}) {
                    push @{$moves{($x+$m2x).','.($y+$m2y)}} => "$x,$y";
                    $moved++;
                    last;
                }
            }
            push @{$moves{"$x,$y"}} => "$x,$y" unless $moved;
        }
    }

    %grid = ();
    for my $key (keys %moves) {
        my $moves = $moves{$key};
        if (@$moves > 1) {
            $grid{$_} = '#' for @$moves;
        } else {
            $grid{$key} = '#';
        }
    }

    push @dir => shift @dir;
    $c++;
    draw();
}


sub draw {
    print "After $c rounds:\n";
    my @x = map { (split ',')[0] } keys %grid;
    my @y = map { (split ',')[1] } keys %grid;
    my ($xmin, $xmax) = (min(@x), max(@x));
    my ($ymin, $ymax) = (min(@y), max(@y));
    my ($width, $height) = ($xmax - $xmin + 1, $ymax - $ymin + 1);

    my $area = $width * $height;
    my $elves = keys %grid;
    my $empty = $area - $elves;

    print "Width range: $xmin, $xmax\n";
    print "Height range: $ymin, $ymax\n";
    print "Grid width: $width, height: $height\n";
    print "Area: $area\n";
    print "Elves: $elves\n";
    print "Empty area: $empty\n";

    for my $y ($ymin-2..$ymax+2) {
        for my $x ($xmin-2..$xmax+2) {
            print $grid{"$x,$y"} ? (color('rgb555', 'on_rgb411'), '⌗') : ('•'), color('reset');
        }
        print "\n";
    }
    print "\n";
}

