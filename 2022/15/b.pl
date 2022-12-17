#!/usr/bin/perl
use strict;

my @sensors;
while (<>) {
    my ($sx, $sy, $bx, $by) = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/ or die "Unrecognized input: $_";
    my $bd = abs($bx - $sx) + abs($by - $sy);
    push @sensors => [$sx, $sy, $bx, $by, $bd];
}

my $c = 0;
# my $ymax = 20; # test
my $ymax = 4_000_000; # input

for my $ly (0..$ymax) {
    printf "%.2f%%\n", 100*$c/$ymax unless $c++ % 10_000;
    my @ranges;
    for (@sensors) {
        my ($sx, $sy, $bx, $by, $bd) = @$_;
        my $ld = abs($ly - $sy);

        # print "Sensor at ($sx, $sy)\n";
        # print "Beacon at ($bx, $by)\n";
        # print "Distance to beacon $bd\n";
        # print "Distance to line $ld\n";

        my $ls = $bd - $ld;
        # print "Width at line $ls\n";
        next if $ls < 0;
        my ($xmin, $xmax) = ($sx - $ls, $sx + $ls);
        # print "Section at line $xmin - $xmax\n";

        push @ranges => [$xmin, $xmax];
        # print "\n";
    }

    @ranges = sort { $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] } @ranges;

    my ($xmin, $xmax) = (0, $ymax);
    for (@ranges) {
        my ($rmin, $rmax) = @$_;
        # print "Range $rmin .. $rmax, x: $xmin\n";
        if ($rmin <= $xmin + 1 && $rmax > $xmin) {
            $xmin = $rmax;
            next;
        } elsif ($rmin > $xmin + 1) {
            last;
        }
    }
    $xmin++;
    if ($xmin <= $xmax) {
        print "Possible position: ($xmin, $ly)\n";
        print "Tuning frequency: ", $xmin * 4_000_000 + $ly, "\n";
        last;
    }
}
