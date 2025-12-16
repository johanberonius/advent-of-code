#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $j = <>;

while (1) {
    my $i = index $j, ':"red"';
    last if $i == -1;
    my $l = length $j;

    my $n = 1;
    for my $p ($i..$l-1) {

        my $c = substr $j, $p, 1;

        $n-- if $c eq '}';
        $n++ if $c eq '{';

        if ($n == 0) {
            substr $j, $i, $p-$i+1, 'red"';
            last;
        }
    }

    $n = 1;
    for my $p (reverse 0..$i) {

        my $c = substr $j, $p, 1;

        $n-- if $c eq '{';
        $n++ if $c eq '}';

        if ($n == 0) {
            substr $j, $p, $i-$p, '"not ';
            last;
        }
    }

}

my $s = sum $j =~ /(-?\d+)/g;

print "Sum: $s\n";
