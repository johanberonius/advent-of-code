#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $i = 0;
my $p;

my @n = map 0+$_, <>;
print "Numbers: ", 0+@n, "\n";

my @m = map { sum @n[$_..$_+2] } 0..@n-3;

for my $c (@m) {
    print "$c\n";
    $i += $p && $p < $c;
    $p = $c;
}

print "Increases: $i\n";
