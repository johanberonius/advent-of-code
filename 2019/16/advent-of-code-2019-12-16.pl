#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @n = <> =~ /(\d)/g;

print "Signal loaded, length: ", 0+@n, "\n";

print "Input signal: ", join('', @n), "\n";


my @p = (0, 1, 0, -1);


for my $p (1..100) {

    my @m;

    for my $i (0..$#n) {

        my $j = 1;
        $m[$i] = abs(sum map {
            my $k = ($j++ / ($i+1)) % @p;
            # print "$_*", $p[$k], " + ";
            $_ * $p[$k]
        } @n) % 10;

        # print "= $m[$i]\n";
    }

    @n = @m;


    # print "After $p phases: ", join('', @n), "\n";
}

print "Final output: ", join('', @n[0..7]), "\n";
