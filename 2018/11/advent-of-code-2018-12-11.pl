#!/usr/bin/perl
use strict;

my $g = 3214;
my %p;

for my $y (1..300) {
    for my $x (1..300) {
        my $r = $x + 10;
        $p{"$x,$y"} = int(($r * $y + $g) * $r % 1000 / 100) - 5;
    }
}

my %s;
for my $j (1..300-2) {
    for my $i (1..300-2) {
        for my $y ($j..$j+2) {
            for my $x ($i..$i+2) {
                $s{"$i,$j"} += $p{"$x,$y"};
            }
        }
    }
}

my ($k) = sort { $s{$b} <=> $s{$a} } keys %s;

print "Fuel cell at $k with total power $s{$k}\n";
