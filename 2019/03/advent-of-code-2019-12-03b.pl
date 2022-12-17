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
    my $s = 0;
    for (split ',', <>) {
        my ($d, $c) = /(\w)(\d+)/;
        die "Unknown direction: $d" unless exists $dx{$d} && exists $dy{$d};
        die "Invalid step number: $c" unless $c > 0;

        while ($c--) {
            $x += $dx{$d};
            $y += $dy{$d};
            $s++;
            $p{"$x,$y"} = $s unless $p{"$x,$y"};
        }
    }
    return %p;
}

my %p1 = path();
my %p2 = path();
my @i = grep $p2{$_}, keys %p1;
my $d = min map $p1{$_} + $p2{$_}, @i;

print "Closest intersection alongs paths: $d\n";
