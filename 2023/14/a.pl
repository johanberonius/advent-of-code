#!/usr/bin/perl
use strict;
use List::Util qw(max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my %g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $e (split '') {
        $g{"$x,$y"} = $e;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "Grid width: $width, height: $height\n";


draw();
sleep 0.5;

my $m;
do {
$m = 0;
    for my $y (0..$height-2) {
        for my $x (0..$width-1) {
            my $s = $y+1;
            my $g = $g{"$x,$y"};
            my $sg = $g{"$x,$s"};

            if ($g eq '.' && $sg eq 'O') {
                $g{"$x,$s"} = $g;
                $g{"$x,$y"} = $sg;
                $m++;
            }
        }
    }
    draw();
} while ($m);

my $w = 0;
for my $k (grep $g{$_} eq 'O', keys %g) {
    my ($x, $y) = split ',', $k;
    $w += $height - $y;
}

print "Weight: $w\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            if ($g eq '#') {
                print color('on_rgb111'), "   ", color('reset');
            } elsif ($g eq 'O') {
                print color('on_rgb333'), " ● ", color('reset');
            } else {
                print color('rgb222', 'on_rgb333'), " • ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    sleep 0.2;
}

