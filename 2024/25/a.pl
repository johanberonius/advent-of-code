#!/usr/bin/perl
use strict;

my $l = [];
my @l = ($l);
while (<>) {
    chomp;
    unless ($_) {
        push @l => ($l = []);
        next;
    }

    tr/.#/01/;
    push @$l => eval "0b$_";
}

my $p = 0;
my $c = 0;
for my $i (0..$#l-1) {
    c: for my $j ($i+1..$#l) {
        $p++;
        for my $n (0..6) {
            next c if $l[$i][$n] & $l[$j][$n];
        }
        $c++;
    }
}

print "Checked $p combinations, found $c with no overlap.\n";
