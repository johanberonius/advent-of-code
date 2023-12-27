#!/usr/bin/perl
use strict;
use List::Util qw(max any);
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my %g;
my ($x, $y) = (0, 0);
my ($sx, $sy) = (1, 0);
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
    next unless any { $g eq $_ } qw(. > < ^ v);

    $s{"$x,$y"} = $v->{"$x,$y"} = $s;

    $m = $s if $m < $s;

    my ($ny, $sy) = ($y-1, $y+1);
    my ($wx, $ex) = ($x-1, $x+1);

    $s++;
    unshift @q => [$x, $ny, $s, {%$v}] if ($g eq '.' && $g{"$x,$ny"} ne 'v') || $g eq '^';
    unshift @q => [$ex, $y, $s, {%$v}] if ($g eq '.' && $g{"$ex,$y"} ne '<') || $g eq '>';
    unshift @q => [$x, $sy, $s, {%$v}] if ($g eq '.' && $g{"$x,$sy"} ne '^') || $g eq 'v';
    unshift @q => [$wx, $y, $s, {%$v}] if ($g eq '.' && $g{"$wx,$y"} ne '>') || $g eq '<';

    print "Iterations: $i, queue: ", 0+@q, "\n" unless $i % 1000;
    # draw();
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

