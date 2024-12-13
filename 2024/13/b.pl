#!/usr/bin/perl
use strict;
use List::Util qw(min);

my ($ax, $ay);
my ($bx, $by);
my ($px, $py);
my $o = 10_000_000_000_000;
my $t = 0;

while (<>) {
    if (/Button A: X\+(\d+), Y\+(\d+)/) {
        ($ax, $ay) = ($1, $2);
    } elsif (/Button B: X\+(\d+), Y\+(\d+)/) {
        ($bx, $by) = ($1, $2);
    } elsif (/Prize: X=(\d+), Y=(\d+)/) {
        ($px, $py) = ($o+$1, $o+$2);

        print "($ax, $ay) ($bx, $by) ($px, $py)\n";


        my ($x1, $y1) = (0, 0);
        my ($x2, $y2) = ($bx, $by);

        my ($x3, $y3) = ($px, $py);
        my ($x4, $y4) = ($px+$ax, $py+$ay);

        my $b = (($x1 - $x3) * ($y3 - $y4) - ($y1 - $y3) * ($x3 - $x4)) /
                (($x1 - $x2) * ($y3 - $y4) - ($y1 - $y2) * ($x3 - $x4));

        my $a = (($x1 - $x2) * ($y1 - $y3) - ($y1 - $y2) * ($x1 - $x3)) /
                (($x1 - $x2) * ($y3 - $y4) - ($y1 - $y2) * ($x3 - $x4));

        print "A: $a, B: $b\n";
        print "x: ", ($a*$ax + $b*$bx), ", y: ", ($a*$ay + $b*$by), "\n";
        print "ix: ", ($x1 + $b * ($x2 - $x1)), ", iy: ", ($y1 + $b * ($y2 - $y1)), "\n";
        print "ix: ", ($x3 - $a * ($x4 - $x3)), ", iy: ", ($y3 - $a * ($y4 - $y3)), "\n";

        if ($a == int $a && $b == int $b) {
            print "Win\n";
            $t += $a * 3 + $b;
        }
        print "\n";
    }
}

print "Tokens: $t\n";
