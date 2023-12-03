#!/usr/bin/perl
use strict;

my %grid;
my %value;
my ($x, $y) = (0, 0);

while (<>) {
    chomp;
    $x = 0;
    for my $e (split '') {
        $grid{"$x,$y"} = $e;
        $x++;
    }
    $y++;
}

my ($width, $height) = ($x, $y);
print "Grid width: $width, height: $height\n";

my $number = 0;
my $sum = 0;
my $nw;
my $f;
for my $y (0..$height-1) {
    for my $x (0..$width) {
        my $grid = $grid{"$x,$y"};
        my $value = 0+$grid;
        if ($value || $grid eq '0') {
            $f = $x unless $number;
            $number *= 10;
            $number += $value;
        } elsif ($number) {
            $value{"$_,$y"} = $number for ($f..$x);
            $number = 0;
        }
    }
}

for my $y (0..$height-1) {
    for my $x (0..$width) {

        my $grid = $grid{"$x,$y"};
        my $value = 0+$grid;
        if ($value || $grid eq '0') {
            $nw = $x - 1 unless $number;
            $number *= 10;
            $number += $value;
        } elsif ($number) {

            my ($nn, $ns) = ($y-1, $y+1);
            my $ne = $x;
            for (grep $grid{$_} eq '*', (map "$_,$nn", $nw..$ne), "$nw,$y", "$ne,$y", (map "$_,$ns", $nw..$ne)) {
                my ($gx, $gy) = split ',';
                my ($gn, $gs) = ($gy-1, $gy+1);
                my ($gw, $ge) = ($gx-1, $gx+1);
                my $gears = 0;

                for (grep $grid{$_} =~ /\d/, (map "$_,$gn", $gw..$ge), "$gw,$gy", "$ge,$gy", (map "$_,$gs", $gw..$ge)) {
                    my ($ax, $ay) = split ',';

                    next if $ay == $y && $ax < $ne && $ax > $nw;

                    my $gear = $value{"$ax,$ay"} or die "Missing value\n";
                    print "$number gears with $gear.\n";
                    $gears++;
                    $sum += $number * $gear;
                    last;
                }
            }

            $number = 0;
        }

    }
}

$sum /= 2;
print "Sum: $sum\n";
