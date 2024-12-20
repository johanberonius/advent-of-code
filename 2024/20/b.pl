#!/usr/bin/perl
use strict;

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
}

print "Steps: $m\n";


my %s;
my @q = [$sx, $sy, 0, 0];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $p, $c) = @$q;

    my $k = "$x,$y";
    if ($p) {
        my $kp = "$x,$y,$p";
        next if exists $c{$kp} && $c{$kp} <= $c;
        $c{$kp} = $c;

        if (exists $c{$k}) {
            $s{$c{$k}-$c}++;
        }
    } else {
        next if exists $c{$k} && $c{$k} < $c;
    }

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
        $p = $c+1;
        push @q => [$w, $y, $p, $c+1] if $g{"$w,$y"} eq '#';
        push @q => [$e, $y, $p, $c+1] if $g{"$e,$y"} eq '#';
        push @q => [$x, $n, $p, $c+1] if $g{"$x,$n"} eq '#';
        push @q => [$x, $s, $p, $c+1] if $g{"$x,$s"} eq '#';
    } elsif ($c < $p+18) {
        push @q => [$w, $y, $p, $c+1] if $g{"$w,$y"};
        push @q => [$e, $y, $p, $c+1] if $g{"$e,$y"};
        push @q => [$x, $n, $p, $c+1] if $g{"$x,$n"};
        push @q => [$x, $s, $p, $c+1] if $g{"$x,$s"};
    }
}


for my $n (sort { $a <=> $b } keys %s) {
    print "There are $s{$n} cheats that save $n picoseconds.\n";
}

my $s = 0;
$s += $_ for map $s{$_}, grep $_ >= 100, keys %s;
print "There are $s cheats that save at least 100 picoseconds.\n";
