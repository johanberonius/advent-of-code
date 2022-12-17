#!/usr/bin/perl
use strict;

my %c;
my ($w, $h);
my ($x, $y) = (0, 0);
while (<>) {
    chomp;
    last unless $_;
    $x = 0;
    $c{$x++ .",$y"} = $_ for split '';
    $y++;
    $w = $x if $x > $w;
}

$h = $y;

for $x (0..$w-1) {
    next unless $c{"$x,". ($h-1)} > 0;
    for $y (reverse 0..$h-1) {
        my $c = $c{"$x,$y"};
        print $c;
    }
    print "\n";
}

print "\n";

print while <>;