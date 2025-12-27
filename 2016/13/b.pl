#!/usr/bin/perl
use strict;
use List::Util qw(sum);
use Term::ANSIColor;

my $n = 1352;
my ($tx, $ty) = (31, 39);
# my $n = 10;
# my ($tx, $ty) = (7, 4);

my %g;
my ($w, $h) = ($tx+10, $ty+10);

for my $y (0..$h-1) {
    for my $x (0..$w-1) {
        my $g = $x*$x + 3*$x + 2*$x*$y + $y + $y*$y + $n;
        $g = sum split "", unpack("b*", pack("L", $g));
        $g = $g % 2 ? '#' : '.';
        $g{"$x,$y"} = $g;

        if ($g eq '#') {
            print color('on_rgb411'), "   ", color('reset');
        } else {
            print color('on_rgb333'), " • ", color('reset');
        }
    }
    print "\n";
}
print "\n";


my @q = ([0, 1, 1]);
my %s;
my $i = 0;
while (@q) {
    my $q = shift @q;
    my ($s, $x, $y) = @$q;
    $i++;

    next unless $g{"$x,$y"} eq '.';
    next if $s{"$x,$y"}++;

    # print "$i: s: $s, x: $x, y: $y, g: ", $g{"$x,$y"}, "\n";

    next if $s == 50;

    push @q => [$s+1, $x+1, $y];
    push @q => [$s+1, $x, $y+1];
    push @q => [$s+1, $x-1, $y];
    push @q => [$s+1, $x, $y-1];
}

print "Locations: ", 0+keys %s, "\n";
