#!/usr/bin/perl
use strict;

my @gamma;
my @epsilon;

my @n = map [map 0+$_, /([01])/g], <>;
print "Numbers: ", 0+@n, "\n";

for my $b (0..@{$n[0]}-1) {

    my $c = grep $_, map $_->[$b], @n;

    print "Bit: $b, ones: $c\n";

    $gamma[$b] = 0+($c > @n / 2);
    $epsilon[$b] = 0+($c <= @n / 2);
}

my $gamma = eval '0b' . join '', @gamma;
print "Gamma: @gamma, $gamma\n";
my $epsilon = eval '0b' . join '', @epsilon;
print "Epsilon: @epsilon, $epsilon\n";

print "Power consumption: ", $gamma * $epsilon, "\n";
