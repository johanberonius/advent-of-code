#!/usr/bin/perl
use strict;

my %grid;
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
my $w;
for my $y (0..$height-1) {
    for my $x (0..$width) {

        my $grid = $grid{"$x,$y"};
        my $value = 0+$grid;
        if ($value || $grid eq '0') {
            $w = $x - 1 unless $number;
            $number *= 10;
            $number += $value;
        } elsif ($number) {

            my ($n, $s) = ($y-1, $y+1);

            print "x:$x, y:$y, ";

            if ( grep $_==0 && $_ ne '0' && $_ ne '.' && $_ ne '', @grid{(map "$_,$n", $w..$x), "$w,$y", "$x,$y", (map "$_,$s", $w..$x)}) {
                $sum += $number;
                print "$number is a part, sum: $sum.\n";
            } else {
                print "$number is not a part.\n";
            }

            $number = 0;
        }

    }
}

print "Sum: $sum\n";
