#!/usr/bin/perl
use strict;
use List::Util qw(min max);


my @r;
while (<>) {
    my ($n, $s, $t, $r) = /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./g or die $_;
    push @r => [$n, $s, $t, $r, 0, 0];
}

for my $e (1..2503) {
# for my $e (1..1000) {

    for my $a (@r) {
        my ($n, $s, $t, $r) = @$a;

        my $p = $t + $r;
        my $c = int $e / $p;
        my $m = $e % $p;
        my $d = $c * $t * $s + min($t, $m) * $s;
        $a->[4] = $d;
    }

    my $max = max map $_->[4], @r;

    for my $a (@r) {
        $a->[5]++ if $a->[4] == $max;
    }
}

my $p = max map $_->[5], @r;
print "Winning points: $p\n";
