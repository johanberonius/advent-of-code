#!/usr/bin/perl
use strict;

my ($x, $y) = (0, 0);
my @start;;
my ($dx, $dy) = (0, 0);
my %g;
while (<>) {
    chomp;
    next unless $_;
    $x = 0;
    for my $e (split '') {
        if ($e eq 'S' or $e eq 'a') {
            push @start => [$x, $y];
            $e = 'a'
        } elsif ($e eq 'E') {
            ($dx, $dy) = ($x, $y);
            $e = 'z'
        }
        $g{$x++ .','. $y} = ord($e) - ord('a');
    }
    $y++;
}

my ($width, $height) = ($x, $y);
print "Grid width: $width, height: $height\n";
print "Starting points: ", 0+@start, "\n";
print "Destination: $dx, $dy\n";

my $gmin;
for (@start) {
    my ($sx, $sy) = @$_;
    print "Starting at: $sx, $sy\n";

    my @q = ([0, $sx, $sy]);
    my $min;
    my %v;
    my $c = 0;
    while (@q) {
        $c++;
        my $q = shift @q;
        my ($steps, $x, $y) = @$q;

        if ($min > 0 && $steps >= $min) {
            next;
        }

        if ($gmin > 0 && $steps >= $gmin) {
            next;
        }

        if (exists $v{"$x,$y"} && $steps >= $v{"$x,$y"}) {
            next;
        }

        if ($x == $dx && $y == $dy) {
            print "Reached destination in $steps steps\n";
            $min = $steps;
            next;
        }

        $v{"$x,$y"} = $steps;

        $steps++;
        my ($w, $e) = ($x-1, $x+1);
        my ($n, $s) = ($y-1, $y+1);
        my $h = $g{"$x,$y"} + 1;

        push @q => [$steps, $x, $n] if $n >= 0 && $g{"$x,$n"} <= $h;
        push @q => [$steps, $x, $s] if $s < $height && $g{"$x,$s"} <= $h;

        push @q => [$steps, $w, $y] if $w >= 0 && $g{"$w,$y"} <= $h;
        push @q => [$steps, $e, $y] if $s < $width && $g{"$e,$y"} <= $h;
    }

    print "Shortest path: $min steps after $c iterations.\n";

    $gmin = $min if $min && (!$gmin || $min < $gmin);
}
print "Shortest of all paths: $gmin steps.\n";
