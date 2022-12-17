#!/usr/bin/perl
use strict;
use List::Util qw(all);
use Math::Utils qw(lcm);

my @m;
while (<>) {
    my ($x, $y, $z) = /x=(-?\d+)\D+y=(-?\d+)\D+z=(-?\d+)/;
    push @m => {
        p => { x => 0+$x, y => 0+$y, z => 0+$z},
        i => { x => 0+$x, y => 0+$y, z => 0+$z},
        v => { x => 0, y => 0, z => 0},
    };
}

print "Scanned positions of ", 0+@m, " moons.\n";

my %r;
for my $d (qw(x y z)) {
    my $t = 0;

    while (1) {
        if ($t > 0 and all { $_->{v}{$d} == 0 and $_->{p}{$d} == $_->{i}{$d} } @m) {
            print "$d repeats after $t steps.\n";
            $r{$d} = $t;
            last;
        }

        # Update velocities with gravity (acceleration)
        for my $i (0..$#m) {
            for my $j (0..$#m) {
                next if $i == $j;
                $m[$i]{v}{$d} += $m[$j]{p}{$d} <=> $m[$i]{p}{$d};
            }
        }

        # Update positions with velocities
        for my $i (0..$#m) {
            $m[$i]{p}{$d} += $m[$i]{v}{$d};
        }

        $t++;
    }
}


my $c = $r{x} * $r{y} * $r{z};
print "x,y,z cycle repeats after $c steps.\n";

# Brute force "Least common multiple"
# $c = 0;
# while (1) {
#     $c += $r{x};
#     if ($c % $r{y} == 0 and $c % $r{z} == 0) {
#         print "x,y,z cycle repeats after minimum $c steps.\n";
#         last;
#     }
# }

my $lcm = lcm(values %r);
print "x,y,z cycle repeats after minimum $lcm steps.\n";
