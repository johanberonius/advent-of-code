#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my $idc = 0;
my @s;
while (<>) {
    push @s => [
        ++$idc,
        $1 eq 'on' || -1,
        [
            0+$2 => 0+$3,
            0+$4 => 0+$5,
            0+$6 => 0+$7,
        ],
        {}
    ] if /(on|off)\s+x=(-?\d+)..(-?\d+)\s*,\s*y=(-?\d+)..(-?\d+)\s*,\s*z=(-?\d+)..(-?\d+)/;
}

print "Steps: ", 0+@s, "\n";

my $c = 0;
my @s2;
for my $s (@s) {
    unshift @s2 => $s;
    print "\n";

    my @q = ($s);
    while (@q) {
        my $q = shift @q;
        print "\n";

        my ($id, $o, $p, $a) = @$q;
        my ($xmin => $xmax, $ymin => $ymax, $zmin => $zmax) = @$p;
        print "Step id: $id, ", ($o == 1 ? 'on' : 'off'), ", x=$xmin..$xmax, y=$ymin..$ymax, z=$zmin..$zmax\n";


        my ($w, $h, $d) = ($xmax - $xmin + 1, $ymax - $ymin + 1, $zmax - $zmin + 1);
        print "Width: $w, height: $h, depth: $d\n";

        my $v = $w * $h * $d;
        print "Volume: $v\n";

        # Unless 'off' at root level (no ancestors)
        if ($o < 0 && !%$a) {
            $o = -$o;
        } else {
            $c += $o * $v;
        }
        print "Cubes on: $c\n";

        print "Skipping ancestors: ", join(' ', sort keys %$a), "\n";

        for my $s2 (@s2) {
            my ($id2, $o2, $p2) = @$s2;
            next if $s2 == $s || $a->{$id2}; # Skip self and all ancestors


            my @i = intersect(@$p, @$p2);
            next unless @i;


            push @q => [++$idc, $o * -$o2, [@i], { %$a, $id => 1, $id2 => 1 }];

            print "Intersection box between $id and $id2, new id: $q[-1][0], @i\n";
        }
    }

}

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
    return ($xmin => $xmax, $ymin => $ymax, $zmin => $zmax,);
}
