#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my ($x, $y) = (0, 0);
my %c;
while (<>) {
    chomp;
    $c{$x++ .','. $y} = $_ for split '';
    $y++;
    $x = 0;
}

my @x = map [split ',']->[0], keys %c;
my @y = map [split ',']->[1], keys %c;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
print "Width: $w\n";
print "Height: $h\n";
print "Size: ", $w * $h, "\n";

my @s = sort grep $c{$_} eq '@', keys %c;
for my $s (@s) {
    my ($sx, $sy) = split ',', $s;
    print "Start position: $sx,$sy\n";
}

my @k = sort grep $_ eq lc $_ && $_ ne uc $_, values %c;
print "Found ", 0+@k, " keys, @k\n";

my %k;
my %d;

for my $py ($ymin .. $ymax) {
    for my $px ($xmin .. $xmax) {
        my $c = $c{"$px,$py"};
        my $d = $d{"$px,$py"};
        if ($c eq '#') {
            print color('on_black'), '   '
        } elsif ($c eq '@') {
            print color('on_magenta'), ' @ ';
        } elsif ($c eq lc $c and $c ne uc $c and !$k{$c}) {
            print color('on_green'), " $c ";
        } elsif ($c eq uc $c and $c ne lc $c and !$k{lc $c}) {
            print color('on_red'), " $c ";
        } elsif ($d) {
            print color('on_cyan'), sprintf('%3d', $d);
        } else {
            print color('on_blue'), ' • ';
        }
    }
    print color('reset'), "\n";
}
