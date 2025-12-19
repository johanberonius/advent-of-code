#!/usr/bin/perl
use strict;

my %g;
my $y = 0;
my $w;
while (<>) {
    chomp;
    my $x = 0;
    $g{$x++ .','. $y} = $_ for split '';
    $w = $x if $w < $x;
    $y++;
}

my $h = $y;
print "Grid size: ${w}x$h\n";


my %n = %g;
for my $i (0..100) {
    print "After $i steps:\n";

    %g = %n;
    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            my ($w, $e) = ($x-1, $x+1);
            my ($n, $s) = ($y-1, $y+1);

            my $g = $g{"$x,$y"};
            my @n = grep $_ eq '#', @g{
                "$w,$n", "$x,$n", "$e,$n",
                "$w,$y",          "$e,$y",
                "$w,$s", "$x,$s", "$e,$s",
            };

            print $g;

            if ($g eq '#') {
                $n{"$x,$y"} = (@n == 2 || @n == 3) ? '#' : '.';
            } else {
                $n{"$x,$y"} = @n == 3 ? '#' : '.';
            }

        }
        print "\n";
    }
    print "\n";

}

my $l = grep $_ eq '#', values %g;
print "Lights: $l\n";
