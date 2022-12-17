#!/usr/bin/perl
use strict;
use List::Util qw(all);

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

my $v = 0;
for my $y (0..$h-1) {
    for my $x (0..$w-1) {
        my $t = $g{"$x,$y"};
        my @top = map $g{"$x,$_"}, 0..$y-1;
        my @left = map $g{"$_,$y"}, 0..$x-1;
        my @bottom = map $g{"$x,$_"}, $y+1..$h-1;
        my @right = map $g{"$_,$y"}, $x+1..$w-1;

        $v++ if
            (all { $_ < $t } @top) ||
            (all { $_ < $t } @left) ||
            (all { $_ < $t } @bottom) ||
            (all { $_ < $t } @right);
    }
}

print "Visible trees: $v\n";
