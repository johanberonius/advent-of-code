#!/usr/bin/perl
use strict;
use List::Util qw(max);

my ($bih) = <> =~ /(\d+)/;
my ($bd) = <> =~ /(\d+)/;
my ($ba) = <> =~ /(\d+)/;

print "Boss: $bih, $bd, $ba\n";


my @w = ([8, 4], [10, 5], [25, 6], [40, 7], [74, 8]);
my @a = ([0, 0], [13, 1], [31, 2], [53, 3], [75, 4], [102, 5]);
my @r1 = ([0, 0, 0], [25, 1, 0], [50, 2, 0], [100, 3, 0]);
my @r2 = ([0, 0, 0], [20, 0, 1], [40, 0, 2], [80, 0, 3]);

my $i = 0;
my $win = 0;
my $min;
for my $w (@w) {
for my $a (@a) {
for my $r1 (@r1) {
for my $r2 (@r2) {
    $i++;

    my $mh = 100;
    my $c = $w->[0] + $a->[0] + $r1->[0] + $r2->[0];
    my $md = $w->[1] + $r1->[1] + $r2->[1];
    my $ma = $a->[1] + $r1->[2] + $r2->[2];

    print "mh: $mh, c: $c, md: $md, ma: $ma ";


    my $bh = $bih;

    while (1) {
        $bh -= max $md - $ba, 1;
        last if $bh <= 0;

        $mh -= max $bd - $ma, 1;
        last if $bh <= 0;
    }

    if ($mh > 0) {
        print "Win!";
        $win++;
        $min = $c if !$min || $min > $c;
    }
    print "\n";

}}}}

print "Interations: $i\n";
print "Wins: $win\n";
print "Minimum cost to win: $min\n";
