#!/usr/bin/perl
use strict;
use List::Util qw(max);
use List::MoreUtils qw(firstidx);

my @b = qw(2	8	8	5	4	2	3	1	5	5	1	2	15	13	5	14);
my %s = (join(',', @b) => 1);
my $s;
my $c = 0;
my $d = 0;

while (++$c) {
    my $m = max @b;
    my $i = firstidx {$_ == $m} @b;
    my $b = $b[$i];
    $b[$i] = 0;
    $b[++$i % @b]++ while $b--;

    my $k = join ',', @b;
    if (!$s && $s{$k}++) {
        $d = $c;
        $s = $k;
    } elsif ($k eq $s) {
        last;
    }
}
my $r = $c - $d;
print "Duplicate found after $d cycles.\n";
print "Reoccuring after $r cycles.\n";
