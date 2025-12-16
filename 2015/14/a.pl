#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $e = 2503;
# my $e = 1000;
my $max;
while (<>) {
    my ($n, $s, $t, $r) = /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./g or die $_;
    my $p = $t + $r;

    my $c = int $e / $p;
    my $m = $e % $p;

    my $d = $c * $t * $s + min($t, $m) * $s;
    $max = $d if $max < $d;

    print "$n s: $s, t: $t, r: $r, p: $p, c: $c, m: $m, d: $d \n";
}

print "Maximum distance: $max\n";
