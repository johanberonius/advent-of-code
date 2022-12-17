#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my $idc = 0;
my @s;
while (<>) {
    push @s => [
        $1 eq 'off',
        [
            0+$2 => 0+$3,
            0+$4 => 0+$5,
            0+$6 => 0+$7,
        ]
    ] if /(on|off)\s+x=(-?\d+)..(-?\d+)\s*,\s*y=(-?\d+)..(-?\d+)\s*,\s*z=(-?\d+)..(-?\d+)/;
}

print "Steps: ", 0+@s, "\n";

my $i = 0;
my $c = volume(@s);
print "Function calls: $i\n";
print "Cubes on: $c\n";

# Input
# Correct: 1_302_784_472_088_899
# Too low: 1_302_477_379_692_870
#
# test4
# Correct: 1_265_621_119_006_734
#          1_265_995_858_259_012


sub volume {
    my @l = @_;
    $i++;

    # print "Function called, list length: ", 0+@l, "\n";

    if (@l == 0) {
        return 0;
    } elsif (@l == 1) {
        my ($off, $p) = @{$l[0]};
        my ($xmin => $xmax, $ymin => $ymax, $zmin => $zmax) = @$p;

        my ($w, $h, $d) = ($xmax - $xmin + 1, $ymax - $ymin + 1, $zmax - $zmin + 1);
        # print "Width: $w, height: $h, depth: $d\n";

        my $v = $w * $h * $d;
        # print "Volume: $v\n";
        return $off ? 0 : $v;
    }

    my @i;
    my ($off, $p) = @{$l[-1]};
    for my $s (@l[0..@l-2]) {
        my ($off2, $p2) = @$s;

        # print "Intersection? from: @$p, to: @$p2\n";

        my @j = intersect(@$p, @$p2);
        next unless @j;
        # print "Yes\n";
        push @i => [$off2, [@j]];
    }

    # print "Intersections: ", 0+@i, "\n";

    return volume(@l[0..@l-2]) + volume($l[-1]) - volume(@i);
}


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
    return ($xmin => $xmax, $ymin => $ymax, $zmin => $zmax,);
}
