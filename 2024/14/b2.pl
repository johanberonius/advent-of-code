#!/usr/bin/perl
use strict;
use Term::ANSIColor;

my ($width, $height) = (101, 103);
my $s = 6577;
my %r;

while (<>) {
    chomp;
    /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/ or die;
    my $x = ($1 + $3 * $s) % $width;
    my $y = ($2 + $4 * $s) % $height;
    $r{"$x,$y"}++;
}

draw();

sub draw {
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $r = $r{"$x,$y"};
            if ($r) {
                print color('on_rgb131'), "   ", color('reset');
            } else {
                print color('on_rgb333'), " • ", color('reset');
            }
        }
        print "\n";
    }
}
