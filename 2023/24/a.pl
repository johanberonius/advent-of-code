#!/usr/bin/perl
use strict;
use Math::Utils qw(sign);

my @p;
while (<>) {
    my $n = '\s*(-?\d+)';
    push @p => [/$n,$n,$n\s*\@$n,$n,$n/];
}

# my ($xmin, $xmax) = my ($ymin, $ymax) = (7, 27);
my ($xmin, $xmax) = my ($ymin, $ymax) = (200_000_000_000_000, 400_000_000_000_000);
my $i = 0;
my $c = 0;
for my $a (0..$#p-1) {
    my ($ax, $ay, $az, $avx, $avy, $avz) = @{$p[$a]};
    for my $b ($a+1..$#p) {
        my ($bx, $by, $bz, $bvx, $bvy, $bvz) = @{$p[$b]};
        print "Hailstone A: $ax, $ay, $az @ $avx, $avy, $avz\n";
        print "Hailstone B: $bx, $by, $bz @ $bvx, $bvy, $bvz\n";

        my $as = $avy / $avx;
        my $bs = $bvy / $bvx;

        my $ao = $ay - $ax * $as;
        my $bo = $by - $bx * $bs;

        if ($as == $bs) {
            print "Hailstones' paths are parallel; they never intersect.\n";
        } else {
            my $x = ($bo - $ao) / ($as - $bs);
            my $y = $ao + $as * $x;

            my $ad = sign($x - $ax) == sign($avx);
            my $bd = sign($x - $bx) == sign($bvx);

            if (!$ad && !$bd) {
                print "Hailstones' paths crossed in the past for both hailstones.\n";
            } elsif (!$ad) {
                print "Hailstones' paths crossed in the past for hailstone A.\n";
            } elsif (!$bd) {
                print "Hailstones' paths crossed in the past for hailstone B.\n";
            } elsif ($x >= $xmin && $x <= $xmax && $y >= $ymin && $y <= $ymax ) {
                print "Hailstones' paths will cross inside the test area (at x=$x, y=$y).\n";
                $c++;
            } else {
                print "Hailstones' paths will cross outside the test area (at x=$x, y=$y).\n";
            }

        }

        print "\n";
        $i++;
    }
}

print "Checked crossings: $i\n";
print "Intersections within test area: $c\n";
