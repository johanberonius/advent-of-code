#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $p = 1;
my $m = 1;
my $c = { v => 0 };
$c->{p} = $c;
$c->{n} = $c;
my $s = $c;
my %s;

while ($m <= 7_125_000) {
    unless ($m % 23) {
        $c = $c->{p} for 1..7;
        $s{$p} += $m + $c->{v};
        $c->{p}{n} = $c->{n};
        $c->{n}{p} = $c->{p};
        $c = $c->{n};
    } else {
        $c = $c->{n};
        $c->{n} = {
            v => $m,
            p => $c,
            n => $c->{n},
        };
        $c = $c->{n};
        $c->{n}{p} = $c;
    }

    $p++;
    $p = 1 if $p > 452;
    $m++;
}

print "Highest score: ", max(values %s), "\n";
