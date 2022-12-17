#!/usr/bin/perl
use strict;
use List::Util qw(min max sum);

my (@c, %g);

while (<>) {
    push @c => [map 0+$_, split /,\s+/];
}

my $xmin = min map $_->[0], @c;
my $xmax = max map $_->[0], @c;
my $ymin = min map $_->[1], @c;
my $ymax = max map $_->[1], @c;
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
my $a2 = $w * $h;

print 0+@c, " coordinates, grid ${xmin}x$ymin -> ${xmax}x$ymax, width: $w, height: $h, area $a2\n";


for my $y ($ymin..$ymax) {
    for my $x ($xmin..$xmax) {
        my $s = sum map abs($c[$_][0] - $x) + abs($c[$_][1] - $y), 0..$#c;
        $g{"$x,$y"} = 1 if $s < 10_000;
    }
}

my $m;
$m++ for values %g;

print "Largest area: $m\n";

for my $y ($ymin..$ymax) {
    for my $x ($xmin..$xmax) {
        my $c = $g{"$x,$y"};
        my $l = exists $g{"$x,$y"} ? $c : '.';
        $l = uc $l if $c[$c][0] == $x && $c[$c][1] == $y;
        print $l;
    }
    print "\n";
}
