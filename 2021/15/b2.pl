#!/usr/bin/perl
use strict;

my ($w, $h) = (0, 0);
my @r;
while (<>) {
    chomp;
    $w = 0;
    $r[$w++][$h] = 0+$_ for split '';
    $h++;
}

my $m = 5;
for my $i (0..$m-1) {
    for my $y (0..$h-1) {
        for my $j (0..$m-1) {
            for my $x (0..$w-1) {
                $r[$j * $w + $x][$i * $h + $y] = ($r[$x][$y] + $i + $j) % 9 || 9;
            }
        }
    }
}

$w *= $m;
$h *= $m;
my $xmax = $w-1;
my $ymax = $h-1;

print "Grid, width: $w, height: $h\n";

my @p = ([0, 0, 0]);
my @m;
my $c = 0;
my $i = 0;
while (@p) {
    my ($x, $y, $r) = @{shift @p};
    $c++;

    next if $m[$x][$y] && $m[$x][$y] <= $r;

    $m[$x][$y] = $r;


    if ($x == $xmax && $y == $ymax) {
        print "Risk at exit: $r\n";
        next;
    }

    next if $m[$xmax][$ymax] && $m[$xmax][$ymax] <= $r;

    my ($n, $s) = ($y-1, $y+1);
    my ($w, $e) = ($x-1, $x+1);

    my $ri = $r+$r[$x][$n];
    push @p => [$x, $n, $ri] if $y > 0 && (!$m[$x][$n] || $m[$x][$n] > $ri);

    my $ri = $r+$r[$w][$y];
    push @p => [$w, $y, $ri] if $x > 0 && (!$m[$w][$y] || $m[$w][$y] > $ri);

    my $ri = $r+$r[$x][$s];
    push @p => [$x, $s, $ri] if $y < $ymax && (!$m[$x][$s] || $m[$x][$s] > $ri);

    my $ri = $r+$r[$e][$y];
    push @p => [$e, $y, $ri] if $x < $xmax && (!$m[$e][$y] || $m[$e][$y] > $ri);

    @p = sort { $a->[2] <=> $b->[2] } @p;

    $i++;
    print "Evaluated $c positions and $i intermediate steps, queue length: ", 0+@p, ".\n" unless $i % 1_000;
}

print "Minimum risk: $m[-1][-1]\n";
print "Evaluated $c positions and $i intermediate steps.\n";
