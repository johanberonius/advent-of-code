#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my @q;
while (<>) {
    my ($d, $n, $c) = /(\w) (\d+) \(#(\w+)\)/ or die;
    push @q => [$d, $n, $c];
}


my ($x, $y) = (0, 0);
my %g = ("$x,$y" => 1);
my %d = (R => [1, 0], D => [0, 1], L => [-1, 0], U => [0, -1]);

for my $q (@q) {
    my ($d, $n, $c) = @$q;
    my ($dx, $dy) = @{$d{$d}};

    for (1..$n) {
        $x += $dx;
        $y += $dy;
        $g{"$x,$y"}++;
    }
}

my @q = [1, 1];
while (@q) {
    my $q = shift @q;
    my ($x, $y) = @$q;
    my $g = $g{"$x,$y"};
    next if $g;
    $g{"$x,$y"}++;

    my ($n, $s) = ($y-1, $y+1);
    my ($w, $e) = ($x-1, $x+1);
    push @q=> [$x, $n], [$e, $y], [$x, $s], [$w, $y];
}

draw();
my $c = values %g;
print "Dug tiles: $c\n";

my $lines;
sub draw {
    my @x = map { (split ',')[0] } keys %g;
    my @y = map { (split ',')[1] } keys %g;
    my ($xmin, $xmax) = (min(@x), max(@x));
    my ($ymin, $ymax) = (min(@y), max(@y));
    my ($width, $height) = ($xmax - $xmin + 1, $ymax - $ymin + 1);

    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    print "Width range: $xmin, $xmax\n";
    $lines++;
    print "Height range: $ymin, $ymax\n";
    $lines++;
    print "Grid width: $width, height: $height\n";
    $lines++;

    for my $y ($ymin-1..$ymax+1) {
        for my $x ($xmin-1..$xmax+1) {
            my $g = $g{"$x,$y"};
            if ($g) {
                print color('on_rgb111'), "   ", color('reset');
            } else {
                print color('rgb222', 'on_rgb333'), " • ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
}
