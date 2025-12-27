#!/usr/bin/perl
use strict;

my $n = 3_014_387;
# my $n = 5;

my @n = (1..$n);
my $i = 0;

while (@n > 1) {
    my $o = ($i + int @n/2) % @n;
    my $s = $n[$i];
    my $l = @n;
    my $r = splice @n, $o, 1;
    print "Removed #$r at $o by #$s at $i, length: $l\n";
    $i++ if $o > $i;
    $i %= @n;
}

print "@n\n";
