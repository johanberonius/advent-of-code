#!/usr/bin/perl
use strict;
use List::Util qw(all);

my @d;
while (<>) {
    my ($o1, $d, $o2) = /Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)\./ or die $_;
    my $o = $o1 + $o2;
    push @d => [$d, $o];
}

my $t = 0;
while (1) {

    last if all {
        my ($d, $o) = @$_;
        ($t + $o) % $d == 0;
    } @d;

    $t++;
}

print "Discs line up at t: $t\n";
