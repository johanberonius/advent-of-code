#!/usr/bin/perl
use strict;

my ($w, $h) = (0, 0);
my %g;
while (<>) {
    chomp;
    next unless $_;
    $w = 0;
    $g{$w++ .','. $h} = 0+$_ for split '';
    $h++;
}

print "Grid width: $w, height: $h\n";

my $m = 0;
for my $y (1..$h-2) {
    for my $x (1..$w-2) {
        my $t = $g{"$x,$y"};
        my @t = map $g{"$x,$_"}, reverse 0..$y-1;
        my @l = map $g{"$_,$y"}, reverse 0..$x-1;
        my @b = map $g{"$x,$_"}, $y+1..$h-1;
        my @r = map $g{"$_,$y"}, $x+1..$w-1;

        my $dt; for (@t) { $dt++; last if $_ >= $t; }
        my $dl; for (@l) { $dl++; last if $_ >= $t; }
        my $db; for (@b) { $db++; last if $_ >= $t; }
        my $dr; for (@r) { $dr++; last if $_ >= $t; }

        my $s = $dt * $dl * $db * $dr;
        $m = $s if $m < $s;
    }
}

print "Max scenic score: $m\n";
