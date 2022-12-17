#!/usr/bin/perl
use strict;
use List::Util qw(min max any);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my ($x, $y) = (0, 0);
my %c;
while (<>) {
    chomp;
    $c{$x++ .','. $y} = $_ for split '';
    $y++;
    $x = 0;
}

my @x = map [split ',']->[0], keys %c;
my @y = map [split ',']->[1], keys %c;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
print "Width: $w\n";
print "Height: $h\n";
print "Size: ", $w * $h, "\n";

my %d;
my %n;
my $c = 0;
while (1) {
    # print "After $c minute:\n";
    # draw();

    my $d = '';
    for my $y ($ymin .. $ymax) {
        for my $x ($xmin .. $xmax) {
            my $c = $c{"$x,$y"};
            my ($n, $s) = ($y - 1, $y + 1);
            my ($w, $e) = ($x - 1, $x + 1);

            $d .= $c;

            my @b = grep $_ eq '#', @c{"$w,$y", "$e,$y", "$x,$n", "$x,$s"};

            if ($c eq '#' and @b != 1) {
                $n{"$x,$y"} = '.';
            } elsif ($c eq '.' and @b == 1 || @b == 2) {
                $n{"$x,$y"} = '#';
            } else {
                $n{"$x,$y"} = $c;
            }
        }
    }

    if ($d{$d}++) {
        print "First recurring state after $c minutes.\n";
        my $m = 1;
        my $s = 0;
        for my $y ($ymin .. $ymax) {
            for my $x ($xmin .. $xmax) {
                $s += $m if $c{"$x,$y"} eq '#';
                $m *= 2;
            }
        }
        print "Biodiversity rating: $s\n";
        draw();
        last;
    }

    %c = %n;
    $c++;
}

my $lines;
sub draw {
    # print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    for my $py ($ymin .. $ymax) {
        for my $px ($xmin .. $xmax) {
            my $c = $c{"$px,$py"};
            if ($c eq '#') {
                print color('white', 'on_black'), ' 🐞 ';
            } elsif ($c eq '.') {
                print color('black', 'on_blue'), '  • ';
            }
        }
        print color('reset'), "\n";
        $lines++;
    }

    # sleep 0.4;
}

