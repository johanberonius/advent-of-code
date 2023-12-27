#!/usr/bin/perl
use strict;
use Math::Utils qw(sign);
use List::Util qw(min max);

my @p;
while (<>) {
    my $n = '\s*(-?\d+)';
    push @p => [/$n,$n,$n\s*\@$n,$n,$n/];
}

my $xmin = min map $_->[0], @p;
my $xmax = max map $_->[0], @p;
my $ymin = min map $_->[1], @p;
my $ymax = max map $_->[1], @p;
my $zmin = min map $_->[2], @p;
my $zmax = max map $_->[2], @p;

my $xr = $xmax - $xmin + 1;
my $yr = $ymax - $ymin + 1;
my $zr = $zmax - $zmin + 1;

print "x range $xr ($xmin - $xmax)\n";
print "y range $yr ($ymin - $ymax)\n";
print "z range $zr ($zmin - $zmax)\n";

my $i = 0;
my ($ax, $ay, $az, $avx, $avy, $avz) = (24, 13, 10 => -3, 1, 2);
print "Stone: $ax, $ay, $az @ $avx, $avy, $avz\n\n";

for my $b (0..$#p) {
    my ($bx, $by, $bz, $bvx, $bvy, $bvz) = @{$p[$b]};
    print "Hailstone: $bx, $by, $bz @ $bvx, $bvy, $bvz\n";

    my $as = $avy / $avx;
    my $bs = $bvy / $bvx;
    my $azs = $avz / $avx;

    my $ao = $ay - $ax * $as;
    my $bo = $by - $bx * $bs;
    my $azo = $az - $ax * $azs;

    if ($as == $bs) {
        print "Hailstones' paths are parallel; they never intersect.\n";
    } else {
        my $x = ($bo - $ao) / ($as - $bs);
        my $y = $ao + $as * $x;
        my $z = $azo + $azs * $x;

        my $ad = sign($x - $ax) == sign($avx);
        my $bd = sign($x - $bx) == sign($bvx);

        my $t = ($x - $ax) / $avx;

        if (!$ad && !$bd) {
            print "Hailstones' paths crossed in the past for both hailstones.\n";
        } elsif (!$ad) {
            print "Hailstones' paths crossed in the past for hailstone A.\n";
        } elsif (!$bd) {
            print "Hailstones' paths crossed in the past for hailstone B.\n";
        } else {
            print "Collision time: $t\n";
            print "Collision position: $x, $y, $z\n";
        }

    }

    print "\n";
    $i++;
}

print "Checked crossings: $i\n";
print "Initial position: $ax, $ay, $az, sum: ", ($ax + $ay + $az), "\n";
