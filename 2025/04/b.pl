#!/usr/bin/perl
use strict;

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);
my ($ex, $ey);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x;
    $y++;
}
$height = $y;

print "Grid width: $width, height: $height\n";

my $t = 0;
while(1) {
    my $r = 0;
    my $i = 0;
    my %h = %g;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            next unless $g eq '@';
            $r++;

            my ($w, $e) = ($x-1, $x+1);
            my ($n, $s) = ($y-1, $y+1);

            next unless 4 > grep $_ eq '@', @g{
                "$w,$n", "$x,$n", "$e,$n",
                "$w,$y",          "$e,$y",
                "$w,$s", "$x,$s", "$e,$s"
            };
            $i++;
            $h{"$x,$y"} = '.';
        }
    }
    %g = %h;
    print "$r rolls, $i removable.\n";
    $t += $i;
    last unless $i;
}

print "Total $t removed.\n";
