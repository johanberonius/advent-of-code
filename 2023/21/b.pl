#!/usr/bin/perl
use strict;
use POSIX qw(floor);

my %g;
my ($x, $y) = (0, 0);
my ($sx, $sy) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $e (split '') {
        if ($e eq 'S') {
            ($sx, $sy) = ($x, $y);
            $e = '.';
        }
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
my %v;
my $i = 0;
my @q = [$sx, $sy, "0 "];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $s) = @$q;
    $i++;
    next if $s{"$x,$y"};

    my ($tx, $ty) = (floor($x / $width), floor($y / $height));
    my ($gx, $gy) = ($x % $width, $y % $height);
    my $g = $g{"$gx,$gy"};
    next unless $g eq '.';

    $s{"$x,$y"} = $s;
    $v{"$tx,$ty"}++ if $s % 2;

    next if $s >= $sx + $width * 2;

    my ($ny, $sy) = ($y-1, $y+1);
    my ($wx, $ex) = ($x-1, $x+1);

    $s++;
    push @q => [$x, $ny, $s], [$ex, $y, $s], [$x, $sy, $s], [$wx, $y, $s];

}

print "Iterations: $i\n";

for my $tk (sort keys %v) {
    print "Reachable plots for tile $tk: $v{$tk}\n";
}

my $n = (26501365 - $sx) / $width;
print "Width in tiles: $n\n";

my $s = 0;
$s += $v{"0,0"} * ($n-1) * ($n-1);

$s += $v{"1,0"} * $n * $n;

$s += $v{"-2,0"};
$s += $v{"2,0"};
$s += $v{"0,-2"};
$s += $v{"0,2"};

$s += $v{"-1,-1"} * ($n-1);
$s += $v{"1,-1"} * ($n-1);
$s += $v{"-1,1"} * ($n-1);
$s += $v{"1,1"} * ($n-1);

$s += $v{"2,1"} * $n;
$s += $v{"2,-1"} * $n;
$s += $v{"-2,1"} * $n;
$s += $v{"-2,-1"} * $n;

print "Reachable plots: $s\n";
