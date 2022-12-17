#!/usr/bin/perl
use strict;

my @n = map 0+$_, split ',', <>;

print "Number of lanternfish: ", 0+@n, "\n";
print "Initial state: ", join(',', @n), "\n";

my $c = 0;

while (1) {

    @n = map $_-1, @n;

    for my $n (@n) {
        if ($n < 0) {
            $n = 6;
            push @n => 8;
        }

    }

    $c++;
    # print "After $c days: ", join(',', @n), "\n";

    last if $c >= 80;
}

print "Number of lanternfish: ", 0+@n, "\n";
