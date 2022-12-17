#!/usr/bin/perl
use strict;
use List::Util qw(any);

my %r = (min => 234208, max => 765869);
my $c = 0;

# It is a six-digit number.
# The value is within the range given in your puzzle input.
P: for ($r{min}..$r{max}) {
    # Two adjacent digits are the same (like 22 in 122345).
    next unless /(\d)\1/;

    # Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
    my @d = split '';
    for my $i (1..$#d) {
        next P if $d[$i] < $d[$i-1];
    }

    $c++;
}

print "Password combinations: $c\n";
