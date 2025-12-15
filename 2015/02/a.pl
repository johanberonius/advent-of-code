#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $s = 0;
while (<>) {
    chomp;
    my ($l, $w, $h) = split 'x';

    my $s1 = $l * $w;
    my $s2 = $w * $h;
    my $s3 = $h * $l;
    $s += 2 * $s1 + 2 * $s2 + 2 * $s3 + min $s1, $s2, $s3;
}

print "Area: $s\n";
