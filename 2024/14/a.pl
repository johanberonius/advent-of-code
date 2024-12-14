#!/usr/bin/perl
use strict;
use List::Util qw(product);
use Term::ANSIColor;

my ($width, $height) = (101, 103);
# my ($width, $height) = (11, 7);
my $s = 100;
my %r;

while (<>) {
    chomp;
    /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/ or die;
    my $x = ($1 + $3 * $s) % $width;
    my $y = ($2 + $4 * $s) % $height;
    $r{"$x,$y"}++;
}

my %q;
for my $y (0..$height-1) {
    for my $x (0..$width-1) {
        my $r = $r{"$x,$y"};

        my $xh = $x < ($width-1)/2 ? 1 : $x > ($width-1)/2 ? 2 : 0;
        my $yh = $y < ($height-1)/2 ? 1 : $y > ($height-1)/2 ? 2 : 0;
        my $bg = $xh && $yh && 'on_rgb433';
        $q{"$xh,$yh"} += $r if $xh && $yh;

        if ($r) {
            print color('on_rgb113'), " $r ", color('reset');
        } else {
            print color($bg || 'on_rgb333'), " • ", color('reset');
        }
    }
    print "\n";
}

print "Safety factor: ", product(values %q), "\n";
