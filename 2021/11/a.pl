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

print "Grid, width: $w, height: $h\n";

my $s = 0;
my $c = 0;
while(1) {
    print "After step $s:\n";

    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            print $d{"$x,$y"};
            $d{"$x,$y"}++;
        }
        print "\n";
    }
    print "\n";

    last if $s >= 100;

    my %f;
    my $f;
    do {
        $f = 0;
        for my $y (0..$h-1) {
            for my $x (0..$w-1) {
                my ($n, $s) = ($y-1, $y+1);
                my ($w, $e) = ($x-1, $x+1);
                if ($d{"$x,$y"} > 9 and !$f{"$x,$y"}++) {
                    $f++;
                    $c++;
                    $d{$_}++ for (
                        "$w,$n", "$x,$n", "$e,$n",
                        "$w,$y",          "$e,$y",
                        "$w,$s", "$x,$s", "$e,$s",
                    );
                }
            }
        }
    } while ($f);

    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            $d{"$x,$y"} = 0 if $d{"$x,$y"} > 9;
        }
    }

    $s++;
}

print "Total flashes: $c\n";
