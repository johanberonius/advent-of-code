#!/usr/bin/perl
use strict;

# my $ly = 10; # test
my $ly = 2_000_000; # input
my %g;
while (<>) {
    my ($sx, $sy, $bx, $by) = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/ or die "Unrecognized input: $_";

    my $bd = abs($bx - $sx) + abs($by - $sy);
    my $ld = abs($ly - $sy);

    print "Sensor at ($sx, $sy)\n";
    print "Beacon at ($bx, $by)\n";
    print "Distance to beacon $bd\n";
    print "Distance to line $ld\n";

    my $ls = $bd - $ld;
    print "Width at line $ls\n";
    print "Section at line ", $sx - $ls, " - ", $sx + $ls,"\n";
    for my $lx ($sx - $ls .. $sx + $ls) {
        $g{"$lx,$ly"} = '#';
    }

    # $g{"$sx,$sy"} = 'S';
    $g{"$bx,$by"} = 'B';

    print "\n";
}

my $c = grep $_ eq '#', values %g;
print "Positions that cannot contain beacon: $c\n";
