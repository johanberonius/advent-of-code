#!/usr/bin/perl
use strict;

my @points;
while (<>) {
    my @n = map 0+$_, split /\s*,\s*/;
    push @points => {
        x => $n[0],
        y => $n[1],
        z => $n[2],
        t => $n[3],
    };
}
# use Data::Dumper;
# print Dumper(\@points);

print "Number of points: ", 0+@points, "\n";

for my $i (0..$#points) {
    for my $j ($i+1..$#points) {
        my $distance =
            abs($points[$i]{x} - $points[$j]{x}) +
            abs($points[$i]{y} - $points[$j]{y}) +
            abs($points[$i]{z} - $points[$j]{z}) +
            abs($points[$i]{t} - $points[$j]{t});
# print "Distance $i => $j: $distance\n";
        if ($distance <= 3) {
            push @{$points[$i]{c}} => $points[$j];
            push @{$points[$j]{c}} => $points[$i];
        }
    }
}

my $constellations = 0;

for my $point (@points) {
    next if $point->{v};
    $constellations++;

    my @constellation = ($point);
    while (@constellation) {
        my $p = shift @constellation;
        push @constellation => @{$p->{c} || []} unless $p->{v}++;
    }
}

print "Number of constellations: $constellations\n";
