#!/usr/bin/perl
use strict;

my @q;
my %d = (0 => 'R', 1 => 'D', 2 => 'L', 3 => 'U');
while (<>) {
    my ($n, $d) = /\w \d+ \(#(\w{5})(\w)\)/ or die;
    push @q => [$d{$d}, eval "0x$n"];
}

my ($x, $y) = (0, 0);
my ($px, $py) = (0, 0);
my %d = (R => [1, 0], D => [0, 1], L => [-1, 0], U => [0, -1]);
my @p;
for my $q (@q) {
    my ($d, $n) = @$q;
    my ($dx, $dy) = @{$d{$d}};

    my ($ix, $iy) = (0, 0);
    ($ix, $iy) = (1, 0) if $px == +1 && $dy == +1;
    ($ix, $iy) = (1, 1) if $py == +1 && $dx == -1;
    ($ix, $iy) = (0, 1) if $px == -1 && $dy == -1;
    ($ix, $iy) = (0, 0) if $py == -1 && $dx == +1;

    ($ix, $iy) = (0, 0) if $px == +1 && $dy == -1;
    ($ix, $iy) = (0, 1) if $py == -1 && $dx == -1;
    ($ix, $iy) = (1, 1) if $px == -1 && $dy == +1;
    ($ix, $iy) = (1, 0) if $py == +1 && $dx == +1;

    if (@p) {
        $p[-1][0] += $ix;
        $p[-1][1] += $iy;
    }

    $x += $dx * $n;
    $y += $dy * $n;

    push @p => [$x, $y];
    ($px, $py) = ($dx, $dy);
}

my $a = 0;
for my $i (0..$#p) {
    my $j = $i - @p + 1;
    my $p1 = $p[$i];
    my $p2 = $p[$j];
    my ($x1, $y1) = @$p1;
    my ($x2, $y2) = @$p2;
    $a += ($y1 + $y2) * ($x1 - $x2);
}

$a /= 2;
print "Area: $a\n";
