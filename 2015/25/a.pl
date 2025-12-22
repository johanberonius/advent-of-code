#!/usr/bin/perl
use strict;

my ($tx, $ty) = (3075, 2981);

my $n = 1;
my ($x, $y) = (1, 1);
my $sy = $y;

while (1) {
    $n++;
    $x++;
    $y--;
    if ($y < 1) {
        $x = 1;
        $y = ++$sy;
    }
    last if $x == $tx && $y == $ty;
}

print "$x x $y: $n\n";
