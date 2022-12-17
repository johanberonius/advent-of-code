#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;
use Time::HiRes qw(time sleep);

my $t1 = time();
my %g;
while (<>) {
    chomp;
    my @points = map [split ','], split /\s+->\s+/;

    for my $i (1..$#points) {
        my ($sx, $sy) = @{$points[$i-1]};
        my ($ex, $ey) = @{$points[$i]};

        # print "($sx, $sy) => ($ex, $ey)\n";
        for my $y (min($sy,$ey)..max($sy,$ey)) {
            for my $x (min($sx,$ex)..max($sx,$ex)) {
                $g{"$x,$y"} = '#';
            }
        }
    }
    # print "\n";
}

my ($sx, $sy) = (500, 0);
$g{"$sx,$sy"} = '+';

my @x = map { (split ',')[0] } keys %g;
my @y = map { (split ',')[1] } keys %g;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;



sand: while (1) {
    my ($x, $y) = ($sx, $sy);
    while (1) {
        my $s = $y+1;
        my ($w, $e) = ($x-1, $x+1);
        if ($s > $ymax) {
            last sand;
        } elsif (!$g{"$x,$s"}) {
            ($x, $y) = ($x, $s);
        } elsif (!$g{"$w,$s"}) {
            ($x, $y) = ($w, $s);
        } elsif (!$g{"$e,$s"}) {
            ($x, $y) = ($e, $s);
        } else {
            $g{"$x,$y"} = 'o';
            # draw();
            next sand;
        }
    }
}

my $c = grep $_ eq 'o', values %g;
print "Units of sand at rest: $c\n";
print "Time: ", time() - $t1, "\n";





my $lines = 0;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    my $w = $xmax - $xmin + 1;
    my $h = $ymax - $ymin + 1;

    print "Map size: $w x $h ($xmin-$xmax x $ymin-$ymax)\n";
    $lines++;
    for my $y ($ymin..$ymax) {
        for my $x ($xmin..$xmax) {
            my $g = $g{"$x,$y"};
            if ($g eq '#') {
                print color('on_black'), $g x 7, color('reset');
            } elsif ($g eq 'o') {
                print color('white', 'on_rgb530'), "   $g   ", color('reset');
            } else {
                print $g ? "   $g   " : '   .   ';
            }
        }
        print "\n";
        $lines++;
    }
    sleep 0.025;
}

