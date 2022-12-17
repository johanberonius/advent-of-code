#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $t = 325489;
my $i = 0;
my $x = 0;
my $y = 0;
my $xi = 0;
my $yi = 0;
my $r = 0;
my %v;

while (++$i) {
    my ($x1, $x2, $x3) = ($x - 1, $x, $x + 1);
    my ($y1, $y2, $y3) = ($y - 1, $y, $y + 1);
    my $v = sum(@v{
       $x1.$y1, $x2.$y1, $x3.$y1,
       $x1.$y2,          $x3.$y2,
       $x1.$y3, $x2.$y3, $x3.$y3,
    }) || 1;

    $v{$x . $y} = $v;
    print "i: $i, x: $x, y: $y, v: $v\n";
    last if $v > $t;

    if ($x == $r && $y == $r) {
        $x = $y = ++$r;
        $xi = 0;
        $yi = -1;
    } elsif ($x == $r && $y == -$r) {
        $xi = -1;
        $yi = 0;
    } elsif ($x == -$r && $y == -$r) {
        $xi = 0;
        $yi = 1;
    } elsif ($x == -$r && $y == $r) {
        $xi = 1;
        $yi = 0;
    }

    $x += $xi;
    $y += $yi;
}
