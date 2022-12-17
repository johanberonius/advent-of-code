#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my @s;
while (<>) {
    push @s => [
        $1 eq 'on' || 0,
        0+$2 => 0+$3,
        0+$4 => 0+$5,
        0+$6 => 0+$7,
    ] if /(on|off)\s+x=(-?\d+)..(-?\d+)\s*,\s*y=(-?\d+)..(-?\d+)\s*,\s*z=(-?\d+)..(-?\d+)/;
}

my $l = 50;
my %r;
for my $s (@s) {
    my ($o, $xmin, $xmax, $ymin, $ymax, $zmin, $zmax) = @$s;
    print "Step: ", ($o ? 'on' : 'off'), ", x=$xmin..$xmax, y=$ymin..$ymax, z=$zmin..$zmax\n";
    for my $z (max($zmin, -$l)..min($zmax, $l)) {
        for my $y (max($ymin, -$l)..min($ymax, $l)) {
            for my $x (max($xmin, -$l)..min($xmax, $l)) {
                $r{"$x,$y,$z"} = $o;
            }
        }
    }
}

my $c = grep $_, values %r;
print "Cubes on: $c\n";
