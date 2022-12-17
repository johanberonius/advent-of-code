#!/usr/bin/perl
use strict;
use List::Util qw(min max all);

my @bots;
while (<>) {
    push @bots => {
        x => 0+$1,
        y => 0+$2,
        z => 0+$3,
        r => 0+$4,
    } if /pos\s*=s*<\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*>\s*,\s*r\s*=\s*(\d+)/;
}

print "Number of bots: ", 0+@bots, "\n";

my @clusters;
for my $bot (@bots) {
    for my $cluster (@clusters) {
        push @$cluster => $bot if all {
            abs($bot->{x} - $_->{x}) +
            abs($bot->{y} - $_->{y}) +
            abs($bot->{z} - $_->{z}) <=
            $bot->{r} + $_->{r}
        } @$cluster;
    }
    push @clusters => [$bot];
}


my ($cluster) = sort { @$b <=> @$a } @clusters;

print "Largest cluster: ", 0+@$cluster, "\n";

my $xmin = max map $_->{x} - $_->{r}, @$cluster;
my $xmax = min map $_->{x} + $_->{r}, @$cluster;
my $width = $xmax - $xmin + 1;

my $ymin = max map $_->{y} - $_->{r}, @$cluster;
my $ymax = min map $_->{y} + $_->{r}, @$cluster;
my $height = $ymax - $ymin + 1;

my $zmin = max map $_->{z} - $_->{r}, @$cluster;
my $zmax = min map $_->{z} + $_->{r}, @$cluster;
my $depth = $zmax - $zmin + 1;

print "x: $xmin..$xmax, width: $width\n";
print "y: $ymin..$ymax, height: $height\n";
print "z: $zmin..$zmax, depth: $depth\n";
print "Cube size: ", $width * $height * $depth, "\n";

my $count;
my %range;
for my $z ($zmin..$zmax) {
    for my $y ($ymin..$ymax) {
        for my $x ($xmin..$xmax) {
            if (all {
                abs($x - $_->{x}) +
                abs($y - $_->{y}) +
                abs($z - $_->{z}) <= $_->{r}
            } @$cluster) {
                $range{"$x,$y,$z"} = abs($x) + abs($y) + abs($z);
                $count++;
            }
        }
    }
}

print "$count coordinates within range of bot cluster\n";
my ($closest) = sort { $range{$a} <=> $range{$b} } keys %range;

print "Closest coordinate in range: $closest, with distance: $range{$closest}\n";
