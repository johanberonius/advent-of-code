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
my $md = 20;
for (keys %c) {
    my ($ox, $oy) = split ',';
    my $sc = $c{$_};

    for my $x ($ox-$md..$ox+$md) {
        for my $y ($oy-$md..$oy+$md) {
            my $d = abs($x-$ox) + abs($y-$oy);
            my $dc = $c{"$x,$y"};
            if ($dc && $d <= $md) {
                $s{$dc - $sc - $d}++;
            }
        }
    }
}

for my $n (sort { $a <=> $b } keys %s) {
    print "There are $s{$n} cheats that save $n picoseconds.\n";
}

my $s = 0;
$s += $_ for map $s{$_}, grep $_ >= 100, keys %s;
print "There are $s cheats that save at least 100 picoseconds.\n";
