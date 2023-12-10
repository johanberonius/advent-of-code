#!/usr/bin/perl
use strict;

my @q = <> =~ /\w/g;
my $s = 0;

my %n;
my $n = 'AAA';
while (<>) {
    $n{$1} = { L => $2, R => $3 } if /(\w+) = \((\w+), (\w+)\)/;
}

while ($n ne 'ZZZ') {
    my $t = $q[$s % @q];
    $n = $n{$n}{$t};
    $s++;
}

print "Steps: $s\n";
