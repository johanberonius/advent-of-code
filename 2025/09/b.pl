#!/usr/bin/perl
use strict;
use List::Util qw(min max any);
use Math::Utils qw(sign);

my @p = map [/(\d+)/g], <>;
print "Points: ", 0+@p, "\n";

my @x = map $_->[0], @p;
my @y = map $_->[0], @p;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;
my $dx = $xmax - $xmin + 1;
my $dy = $ymax - $ymin + 1;
my $a = $dx * $dy;

print "Grid $xmin,$ymin - $xmax,$ymax\n";
print "Width: $dx, height: $dy\n";
print "Grid area: $a\n";
my $p = 0;
for my $pi (0..$#p) {
    my ($l1x, $l1y) = @{$p[$pi-1]};
    my ($l2x, $l2y) = @{$p[$pi]};
    my $dx = abs($l2x - $l1x);
    my $dy = abs($l2y - $l1y);
    $p += $dx + $dy;
}
print "Polygon perimeter: $p\n";


my $max;
my $i;
my %s;
for my $p1 (@p) {
    my ($p1x, $p1y) = @$p1;
    p: for my $p2 (@p) {
        next if $p1 == $p2;
        next if $s{"$p1,$p2"}++;
        next if $s{"$p2,$p1"}++;
        my ($p2x, $p2y) = @$p2;
        $i++;

        my $xmin = min $p1x, $p2x;
        my $xmax = max $p1x, $p2x;
        my $ymin = min $p1y, $p2y;
        my $ymax = max $p1y, $p2y;
        next if any {
            my ($px, $py) = @$_;
            $xmin < $px && $px < $xmax &&
            $ymin < $py && $py < $ymax;
        } @p;


        for my $pi (0..$#p) {
            my ($l1x, $l1y) = @{$p[$pi-1]};
            my ($l2x, $l2y) = @{$p[$pi]};

            my $dx = sign($l2x - $l1x);
            my $dy = sign($l2y - $l1y);
            while(1) {
                $l1x += $dx;
                $l1y += $dy;
                last if $l1x == $l2x && $l1y == $l2y;
                next p if $xmin < $l1x && $l1x < $xmax &&
                          $ymin < $l1y && $l1y < $ymax;
            }
        }

        my $dx = abs($p2x - $p1x) + 1;
        my $dy = abs($p2y - $p1y) + 1;
        my $a = $dx * $dy;
        if ($max <= $a) {
            $max = $a;
            print "New max area: $max, from $p1x,$p1y - $p2x,$p2y\n";
        }
    }
}

print "Iterations: $i\n";
print "Max area: $max\n";
