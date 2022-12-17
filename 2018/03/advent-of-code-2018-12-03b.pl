#!/usr/bin/perl
use strict;

my ($c, @l, %g);

while (<>) {
    $c++;
    push @l => [/#(\d+)\s+@\s+(\d+),(\d+):\s+(\d+)x(\d+)/];
}

foreach (@l) {
    my ($i, $x, $y, $w, $h) = @$_;
    for my $m ($y..$y+$h-1) {
        for my $n ($x..$x+$w-1) {
            $g{"$n,$m"}++;
        }
    }
}

my $o;
loop: foreach (@l) {
    my ($i, $x, $y, $w, $h) = @$_;
    for my $m ($y..$y+$h-1) {
        for my $n ($x..$x+$w-1) {
            next loop unless $g{"$n,$m"} == 1;
        }
    }
    $o = $i;
}

my $d = grep $_ >= 2, values %g;

print "$c rectangles, overlap: $d, ID with no overlap: $o\n";
