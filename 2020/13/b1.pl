#!/usr/bin/perl
use strict;

my $t = <>;
my $o = 0;
my %b;
for (split ',', <>) {
    $b{0+$_} = $o if 0+$_;
    $o++;
}

print "Number of busses: ", 0+keys %b, "\n";

my ($m) = grep $b{$_} == 0, keys %b;
my $n = 0;

l: while ($n += $m) {
    for (keys %b) {
        next l unless ($n + $b{$_}) % $_ == 0;
    }
    last;
}

print "Earliest sequential bus departure time: $n\n";
