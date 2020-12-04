#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my ($x, $y) = (0, 0);
my ($w, $h);
my %g;
while (<>) {
    chomp;
    $g{$x++ .','. $y} = $_ for split '';
    $y++;
    $w = $x;
    $h = $y;
    $x = 0;
}

print "Width: $w\n";
print "Height: $h\n";
print "Size: ", $w * $h, "\n";

my $p = 1;
my $xmax = 0;
my %m;
for my $d ([1, 1], [3, 1], [5, 1], [7, 1], [1, 2]) {
    my ($dx, $dy) = @$d;
    print "Slope: $dx/$dy\n";

    my ($x, $y) = (0, 0);
    my $t = 0;
    while ($y < $h) {
        my $lx = $x % $w;
        $t++ if $g{"$lx,$y"} eq '#';
        $m{"$x,$y"} = $g{"$lx,$y"} eq '#' ? 'X' : 'O';
        $x += $dx;
        $y += $dy;
        $xmax = $x if $x > $xmax;
    }

    print "Encountered $t trees.\n";
    $p *= $t;
}
print "Max X: $xmax\n";
print "Product: $p\n";

exit;

for my $y (0 .. $h) {
    for my $x (0 .. $xmax) {
        my $lx = $x % $w;
        my $g = $g{"$lx,$y"};
        my $m = $m{"$x,$y"};
        if ($m eq 'X') {
            print color('on_rgb420'), ' X '
        } elsif ($m eq 'O') {
            print color('on_rgb115'), ' O '
        } elsif ($g eq '#') {
            print color('on_rgb310'), ' # '
        } elsif ($g eq '.') {
            print color('on_blue'), ' • ';
        } else {
            print color('reset'), '   ';
        }
    }
    print color('reset'), "\n";
}

