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
        my $g = $g{"$x,$y"};
        next unless $g eq 'X';
        my ($n1, $n2, $n3) = ($y-1, $y-2, $y-3);
        my ($s1, $s2, $s3) = ($y+1, $y+2, $y+3);
        my ($w1, $w2, $w3) = ($x-1, $x-2, $x-3);
        my ($e1, $e2, $e3) = ($x+1, $x+2, $x+3);
        $c++ if qq($g{"$e1,$y"}$g{"$e2,$y"}$g{"$e3,$y"}) eq 'MAS';
        $c++ if qq($g{"$w1,$y"}$g{"$w2,$y"}$g{"$w3,$y"}) eq 'MAS';

        $c++ if qq($g{"$x,$n1"}$g{"$x,$n2"}$g{"$x,$n3"}) eq 'MAS';
        $c++ if qq($g{"$x,$s1"}$g{"$x,$s2"}$g{"$x,$s3"}) eq 'MAS';

        $c++ if qq($g{"$e1,$n1"}$g{"$e2,$n2"}$g{"$e3,$n3"}) eq 'MAS';
        $c++ if qq($g{"$e1,$s1"}$g{"$e2,$s2"}$g{"$e3,$s3"}) eq 'MAS';

        $c++ if qq($g{"$w1,$n1"}$g{"$w2,$n2"}$g{"$w3,$n3"}) eq 'MAS';
        $c++ if qq($g{"$w1,$s1"}$g{"$w2,$s2"}$g{"$w3,$s3"}) eq 'MAS';
    }
}

print "Words: $c\n";
