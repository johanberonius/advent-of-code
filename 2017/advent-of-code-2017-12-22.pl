#!/usr/bin/perl
use strict;

my %g;
my %i;
my ($x, $y) = (0, 0);
my ($dx, $dy) = (0, -1);
my %m = ('#' => 1, '.' => 0);
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
while ($c < 10_000) {
    $c++;
    my $p = "$x,$y";
    my $r = $g{$p} || -1;
    ($dx, $dy) = (-$r * $dy, $r * $dx);
    $i{$g{$p} = !$g{$p}}++;
    $x += $dx;
    $y += $dy;
}

print "After $c iterations: $i{1} nodes have been infected and $i{''} cleaned.\n";
