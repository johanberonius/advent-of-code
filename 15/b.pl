#!/usr/bin/perl
use strict;

for my $sn (
    [0,3,6],
    [1,3,2],
    [2,1,3],
    [1,2,3],
    [2,3,1],
    [3,2,1],
    [3,1,2],
    [18,8,0,5,4,1,20],
    ) {

    my @n = @$sn;
    my %a;
    my %s;
    my %t;
    my $n;
    my $t = 0;

    while ($t < 30_000_000) {
        $t++;

        if ($t <= @n) {
            $n = $n[$t-1];
        } else {
            my $p = $n = $n[$t-2];
            $n[$t-1] = $n = $s{$n} <= 1 ? 0 : $a{$p};
        }

        $a{$n} = $t - $t{$n};
        $t{$n} = $t;
        $s{$n}++;
    }

    print "Starting numbers @$sn, turn $t number $n\n";
}
