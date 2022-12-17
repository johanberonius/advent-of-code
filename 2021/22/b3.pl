#!/usr/bin/perl
use strict;
use List::Util qw(min max sum);
use Math::Utils qw(sign);

my $idc = 0;
my @s;
while (<>) {
    push @s => [
        $1 eq 'off' ? 0 : ($3 - $2 + 1) * ($5 - $4 + 1) * ($7 - $6 + 1),
        0+$2 => 0+$3,
        0+$4 => 0+$5,
        0+$6 => 0+$7,
    ] if /(on|off)\s+x=(-?\d+)..(-?\d+)\s*,\s*y=(-?\d+)..(-?\d+)\s*,\s*z=(-?\d+)..(-?\d+)/;
}

print "Steps: ", 0+@s, "\n";


# Input
# Correct: 1_302_784_472_088_899
# Too low: 1_302_477_379_692_870
#
# test4
# Correct: 1_265_621_119_006_734
#          1_265_995_858_259_012


my $c = 0;
my @l;
for my $s (@s) {
    my ($v, @p) = @$s;
    my @n = ($s);
    for my $l (@l) {
        my ($v2, @p2) = @$l;
        my ($vi, @pi) = intersect(@p, @p2);
        next unless @pi;
        push @n => [$vi * -sign($v2), @pi];
    }
    push @l => @n;
}

print "Number of cubiods in list: ", 0+@l, "\n";
my $c = sum map $_->[0], @l;
print "Cubes on: $c\n";



sub intersect {
    my (
        $xmin1 => $xmax1, $ymin1 => $ymax1, $zmin1 => $zmax1,
        $xmin2 => $xmax2, $ymin2 => $ymax2, $zmin2 => $zmax2,
    ) = @_;

    my ($xmin, $xmax) = (max($xmin1, $xmin2), min($xmax1, $xmax2));
    my $w = $xmax - $xmin + 1;
    return if $w <= 0;
    my ($ymin, $ymax) = (max($ymin1, $ymin2), min($ymax1, $ymax2));
    my $h = $ymax - $ymin + 1;
    return if $h <= 0;
    my ($zmin, $zmax) = (max($zmin1, $zmin2), min($zmax1, $zmax2));
    my $d = $zmax - $zmin + 1;
    return if $d <= 0;
    my $v = $w * $h * $d;
    return ($v, $xmin => $xmax, $ymin => $ymax, $zmin => $zmax,);
}
