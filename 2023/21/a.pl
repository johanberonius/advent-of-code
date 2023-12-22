#!/usr/bin/perl
use strict;
use List::Util qw(max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my %g;
my ($x, $y) = (0, 0);
my ($sx, $sy) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $e (split '') {
        if ($e eq 'S') {
            ($sx, $sy) = ($x, $y);
            $e = '.';
        }
        $g{"$x,$y"} = $e;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";

my %s;
my %v;
my $i = 0;
my @q = [$sx, $sy, "0 "];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $s) = @$q;
    $i++;
    next if $s{"$x,$y"};

    my $g = $g{"$x,$y"};
    next unless $g eq '.';

    $s{"$x,$y"} = $s;
    $v{"$x,$y"} = $s unless $s % 2;

    next if $s >= 64;

    my ($ny, $sy) = ($y-1, $y+1);
    my ($wx, $ex) = ($x-1, $x+1);

    $s++;
    push @q => [$x, $ny, $s], [$ex, $y, $s], [$x, $sy, $s], [$wx, $y, $s];

    # draw();
}


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $s = $s{"$x,$y"};
            my $v = $v{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('rgb555', 'on_rgb114'), " • ", color('reset');
            } elsif ($s) {
                print color($v ? 'on_rgb114' : 'on_rgb333');
                printf "%-2d ", $s;
                print color('reset');
            } elsif ($g eq '#') {
                print color('on_rgb111'), "   ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    sleep 0.1;
}

print "Iterations: $i\n";
my $v = keys %v;
print "Reachable plots: $v\n";
