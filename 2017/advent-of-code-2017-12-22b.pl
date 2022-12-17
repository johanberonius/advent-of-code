#!/usr/bin/perl
use strict;

my %g;
my %i;
my ($x, $y) = (0, 0);
my ($dx, $dy) = (0, -1);
my %m = ('#' => 2, '.' => 0);
while (<>) {
    chomp;
    my @r = map $m{$_}, split '';
    @g{map "$_,$y", 0..$#r} = @r;
    $x = 0+@r;
    $y++;
}

$x = int $x / 2;
$y = int $y / 2;

my $c = 0;
while ($c < 10_000_000) {
    $c++;
    my $p = "$x,$y";
    my $r = (-1, 0, 1, 0)[$g{$p}];
    ($dx, $dy) = (-$r * $dy, $r * $dx) if $r;
    ($dx, $dy) = (-$dx, -$dy) if $g{$p} == 3;
    $g{$p}++;
    $g{$p} %= 4;
    $i{$g{$p}}++;
    $x += $dx;
    $y += $dy;
}

print "After $c iterations: $i{0} nodes have been cleaned, $i{1} weakened, $i{2} infected and $i{2} flagged.\n";
