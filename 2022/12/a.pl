#!/usr/bin/perl
use strict;

my ($x, $y) = (0, 0);
my ($sx, $sy) = (0, 0);
my ($dx, $dy) = (0, 0);
my %g;
while (<>) {
    chomp;
    next unless $_;
    $x = 0;
    for my $e (split '') {
        if ($e eq 'S') {
            ($sx, $sy) = ($x, $y);
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
print "Start: $sx, $sy\n";
print "Destination: $dx, $dy\n";

my @q = ([0, $sx, $sy]);
my $min = 0;
my %v;
my $c = 0;
while (@q) {
    $c++;
    # print "Queue length: ", 0+@q, "\n" unless $c % 1000;
    # @q = sort { our ($a, $b); $a->{s} <=> $b->{s} } @q;
    my $q = shift @q;
    my ($steps, $x, $y) = @$q;

    # print "Visit $x,$y in $steps steps, visited previously in ", $v{"$x,$y"}, " steps.\n";
    # last if $c > 10;

    if ($min > 0 && $steps >= $min) {
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
