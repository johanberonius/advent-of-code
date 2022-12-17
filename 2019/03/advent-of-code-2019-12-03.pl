#!/usr/bin/perl
use strict;
use List::Util qw(min sum);

my %dx = (
    R => 1,
    U => 0,
    L => -1,
    D => 0,
);

my %dy = (
    R => 0,
    U => -1,
    L => 0,
    D => 1,
);

sub path() {
    my %p;
    my ($x, $y) = (0, 0);
    for (split ',', <>) {
        my ($d, $c) = /(\w)(\d+)/;

        while ($c--) {
            $x += $dx{$d};
            $y += $dy{$d};
            $p{"$x,$y"}++;
        }
    }
    return %p;
}

my %p1 = path();
my %p2 = path();
my @i = grep $p2{$_}, keys %p1;
my $d = min map sum(map abs($_), split ','), @i;

print "Closest intersection from central port: $d\n";
