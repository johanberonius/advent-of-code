#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my @p;
while (<>) {
    my %p;
    @p{qw(x y vx vy)} = /position=<\s*(-?\d+),\s*(-?\d+)>\s+velocity=<\s*(-?\d+),\s*(-?\d+)>/;
    push @p => \%p;
}

my $a1;
my $c = 0;
my %b;

while () {
    my $xmin = min map $_->{x}, @p;
    my $xmax = max map $_->{x}, @p;
    my $ymin = min map $_->{y}, @p;
    my $ymax = max map $_->{y}, @p;
    my $w = $xmax - $xmin + 1;
    my $h = $ymax - $ymin + 1;
    my $a2 = $w * $h;
    last if $a1 && $a2 > $a1;
    $a1 = $a2;

    print 0+@p, " points, iteration: $c, grid $xmin,$ymin -> $xmax,$ymax, width: $w, height: $h, area: $a2\n";

    %b = (
        xmin => $xmin,
        xmax => $xmax,
        ymin => $ymin,
        ymax => $ymax,
    );
    $b{"$_->{x},$_->{y}"} = 1 for @p;

    for my $p (@p) {
        $p->{x} += $p->{vx};
        $p->{y} += $p->{vy};
    }

    $c++;
}


for my $y ($b{ymin}..$b{ymax}) {
    for my $x ($b{xmin}..$b{xmax}) {
        print $b{"$x,$y"} ? '#' : '.';
    }
    print "\n";
}
