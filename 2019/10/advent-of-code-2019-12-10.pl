#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $y = 0;
my $x;
my %a;

while (<>) {
    chomp;
    $x = 0;
    for (split '') {
        $a{"$x,$y"}++ if $_ eq '#';
        $x++;
    }

    $y++;
}

my $w = $x;
my $h = $y;
print "Asteroid field, width: $w, height: $h\n";

my $n = values %a;
print "Number of asteroids: $n\n";

print "Max number of obstruction checks: ", $n**3, "\n";

my $c = 0;
my %v;
for (keys %a) {
    my ($ox, $oy) = split ',';

    A: for (keys %a) {
        my ($x, $y) = split ',';
        next if $x == $ox && $y == $oy;
        my ($dx, $dy) = ($x - $ox, $y - $oy);
        my $a = atan2($dy, $dx);
        my $l = $dx**2 + $dy**2;

        for (keys %a) {
            my ($x2, $y2) = split ',';
            next if $x2 == $ox && $y2 == $oy;
            next if $x2 == $x && $y2 == $y;
            my ($dx2, $dy2) = ($x2 - $ox, $y2 - $oy);
            my $a2 = atan2($dy2, $dx2);
            my $l2 = $dx2**2 + $dy2**2;
            $c++;

            next A if $a == $a2 && $l > $l2;
        }

        $v{"$ox,$oy"}++;
    }
}

print "Number of obstruction checks: $c\n";

my $m = max values %v;
print "Maximum visible asteroids: $m\n";

my ($p) = sort { $v{$b} <=> $v{$a} } keys %v;
print "Position of best asteroid: $p\n";
