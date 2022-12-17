#!/usr/bin/perl
use strict;

my $g = 3214;
my $w = 300;
my %p;

print "Grid size: $w, serial $g\n";

for my $y (1..$w) {
    for my $x (1..$w) {
        my $r = $x + 10;
        $p{"$x,$y"} = int(($r * $y + $g) * $r % 1000 / 100) - 5;
    }
}

my %s;
$s{"$_,1"} = $p{$_} for keys %p;

for my $s (2..$w) {
    print "Square: $s\n";
    for my $j (1..$w-$s+1) {
        for my $i (1..$w-$s+1) {
            my $k = "$i,$j,$s";
            my $k2 = "$i,$j,". ($s-1);
            $s{$k} = $s{$k2};
            my $xmax = $i+$s-1;
            my $ymax = $j+$s-1;
            for my $y ($j..$ymax) {
                $s{$k} += $p{"$xmax,$y"};
            }
            for my $x ($i..$xmax-1) {
                $s{$k} += $p{"$x,$ymax"};
            }
        }
    }
}

my ($k) = sort { $s{$b} <=> $s{$a} } keys %s;

print "Fuel cell at $k with total power $s{$k}\n";

__END__
for my $s (1..$w) {
    print "Grid size: $s\n";
    for my $y (1..$w-$s+1) {
        for my $x (1..$w-$s+1) {
            my $v = $s{"$x,$y,$s"} || 0;
            print $v < 0 ? '' : ' ', "$v ";
        }
        print "\n";
    }
    print "\n";
}
