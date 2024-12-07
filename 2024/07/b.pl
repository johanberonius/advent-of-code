#!/usr/bin/perl
use strict;
use List::Util qw(any);

my $c = 0;
while (<>) {
    my ($s, $n, @n) = split '\D+';
    my @c = ($n);
    for my $n (@n) {
        @c = map { $_ + $n, $_ * $n, "$_$n" } @c;
    }

    $c += $s if any { $_ == $s } @c;
}

print "Sum: $c\n";
