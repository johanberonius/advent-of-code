#!/usr/bin/perl
use strict;

my @n = split ' ', <>;

my $i = 0;
while (1) {
    print "@n\n";
    last if ++$i > 25;

    @n = map {
        my $l = length $_;
        if ($_ == 0) {
            1;
        } elsif($l % 2 == 0) {
            (0+substr($_, 0, $l/2), 0+substr($_, $l/2));
        } else {
            $_ *= 2024;
        }
    } @n;
}

print "Stones: ", 0+@n, "\n";
