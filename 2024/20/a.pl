#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);
my ($ex, $ey);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        if ($g eq 'S') {
            ($sx, $sy) = ($x, $y);
            $g = '.';
        } elsif ($g eq 'E') {
            ($ex, $ey) = ($x, $y);
            $g = '.';
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";
print "End position: $ex, $ey\n";

my %c;
my $m;

my @q = [$sx, $sy, 0];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $c) = @$q;

    my $k = "$x,$y";
    next if exists $c{$k} && $c{$k} <= $c;
    $c{$k} = $c;

    if ($x == $ex && $y == $ey) {
        $m = $c;
        last;
    }

    my ($w, $e) = ($x-1, $x+1);
    my ($n, $s) = ($y-1, $y+1);
    push @q => [$w, $y, $c+1] if $g{"$w,$y"} eq '.';
    push @q => [$e, $y, $c+1] if $g{"$e,$y"} eq '.';
    push @q => [$x, $n, $c+1] if $g{"$x,$n"} eq '.';
    push @q => [$x, $s, $c+1] if $g{"$x,$s"} eq '.';

    draw();
}

print "Steps: $m\n";


my %s;
my @q = [$sx, $sy, 0, 0];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $p, $c) = @$q;

    my $k = "$x,$y";

    if ($p && $c{$k}) {
        $s{$c{$k}-$c}++;
        next;
    }

    next if exists $c{$k} && $c{$k} < $c;

    if ($x == $ex && $y == $ey) {
        $m = $c;
        last;
    }

    my ($w, $e) = ($x-1, $x+1);
    my ($n, $s) = ($y-1, $y+1);
    push @q => [$w, $y, $p, $c+1] if $g{"$w,$y"} eq '.';
    push @q => [$e, $y, $p, $c+1] if $g{"$e,$y"} eq '.';
    push @q => [$x, $n, $p, $c+1] if $g{"$x,$n"} eq '.';
    push @q => [$x, $s, $p, $c+1] if $g{"$x,$s"} eq '.';

    if (!$p) {
        push @q => [$w, $y, 1, $c+1] if $g{"$w,$y"} eq '#';
        push @q => [$e, $y, 1, $c+1] if $g{"$e,$y"} eq '#';
        push @q => [$x, $n, 1, $c+1] if $g{"$x,$n"} eq '#';
        push @q => [$x, $s, 1, $c+1] if $g{"$x,$s"} eq '#';
    }
}


for my $n (sort { $a <=> $b } keys %s) {
    print "There are $s{$n} cheats that save $n picoseconds.\n";
}

my $s = 0;
$s += $_ for map $s{$_}, grep $_ >= 100, keys %s;
print "There are $s cheats that save at least 100 picoseconds.\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $c = $c{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('on_rgb411'), " S ", color('reset');
            } elsif ($x == $ex && $y == $ey) {
                print color('on_rgb131'), " E ", color('reset');
            } elsif ($c) {
                print color('on_rgb114'), " • ", color('reset');
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
    sleep 0.02;
}
