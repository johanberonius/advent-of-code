#!/usr/bin/perl
use strict;

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

my $c = 0;
for my $y (0..$height-1) {
    for my $x (0..$width-1) {
        my ($n, $s) = ($y-1, $y+1);
        my ($w, $e) = ($x-1, $x+1);
        my $b = qq($g{"$w,$n"}$g{"$x,$y"}$g{"$e,$s"});
        my $f = qq($g{"$w,$s"}$g{"$x,$y"}$g{"$e,$n"});
        $c++ if ($b eq 'MAS' || $b eq 'SAM') && ($f eq 'MAS' || $f eq 'SAM');
    }
}

print "Words: $c\n";
