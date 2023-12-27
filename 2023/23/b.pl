#!/usr/bin/perl
use strict;
use List::Util qw(max any);
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my %g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        $g = '.' if any { $g eq $_ } qw(> < ^ v);
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

my ($sx, $sy) = (1, 0);
my ($ex, $ey) = ($width - 2, $height - 1);

print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";

my %s;
my $m;
my $i = 0;
my @q = [$sx, $sy, "0 ", {}];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $s, $v) = @$q;
    $i++;
    next if $v->{"$x,$y"};

    my $g = $g{"$x,$y"};
    next unless $g eq '.';

    $s{"$x,$y"} = $v->{"$x,$y"} = $s;

    if ($x == $ex && $y == $ey && $m < $s) {
        $m = $s;
        print "Found new max steps: $m\n";
    }

    my ($ny, $sy) = ($y-1, $y+1);
    my ($wx, $ex) = ($x-1, $x+1);

    $s++;
    unshift @q => [$ex, $y, $s, {%$v}];
    unless ($x == 113 && $y == 137) {
        unshift @q => [$x, $ny, $s, {%$v}];
        unshift @q => [$x, $sy, $s, {%$v}];
        unshift @q => [$wx, $y, $s, {%$v}];
    }

    print "Iterations: $i, queue: ", 0+@q, "\n" unless $i % 1000;
    draw();
}

print "Iterations: $i\n";
print "Max steps: $m\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $s = $s{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('rgb555', 'on_rgb114'), " • ", color('reset');
            } elsif ($s) {
                print color('on_rgb114');
                printf "%-3d", $s;
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
    sleep 0.05;
}
