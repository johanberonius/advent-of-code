#!/usr/bin/perl
use strict;

my ($w, $h) = (0, 0);
my %d;
while (<>) {
    chomp;
    $w = 0;
    $d{$w++ .','. $h} = 0+$_ for split '';
    $h++;
}

print "Depth map, width: $w, height: $h\n";

my $r = 0;
for my $y (0..$h-1) {
    for my $x (0..$w-1) {
        my ($n, $s) = ("$x,". ($y-1), "$x,". ($y+1));
        my ($w, $e) = (($x-1) .",$y", ($x+1) .",$y");
        my $d = $d{"$x,$y"};

        if (!defined $d{$n} || $d{$n} > $d and
            !defined $d{$s} || $d{$s} > $d and
            !defined $d{$e} || $d{$e} > $d and
            !defined $d{$w} || $d{$w} > $d) {

            print "x: $x, y: $y, d: $d is low point, n: $n ($d{$n}), s: $s ($d{$s}), w: $w ($d{$w}), e: $e ($d{$e})\n";
            $r += $d + 1;

        }
    }
}

print "Risk level: $r\n";
