#!/usr/bin/perl
use strict;

my $n = 3014387;
# my $n = 5;

my @n = (1..$n);
my $i = 1;

while (@n > 1) {
    my $r = splice @n, $i, 1;
    print "Removed #$r at $i, length: ", 0+@n, "\n";
    $i++;
    $i %= @n;
}

print "@n\n";

