#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $s = 0;
while (<>) {
    chomp;
    my ($l, $w, $h) = split 'x';

    my $c1 = 2 * $l + 2 * $w;
    my $c2 = 2 * $w + 2 * $h;
    my $c3 = 2 * $h + 2 * $l;
    my $v = $l * $w * $h;
    $s += $v + min $c1, $c2, $c3;
}

print "Length: $s\n";
