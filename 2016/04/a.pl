#!/usr/bin/perl
use strict;

my $s = 0;
while (<>) {
    print;
    my ($n, $i, $c) = /([a-z-]+)-(\d+)\[([a-z]{5})\]/ or die $_;

    my %n;
    $n{$_}++ for grep /[a-z]/, split '', $n;

    my @l = sort { $n{$b} <=> $n{$a} or $a cmp $b } keys %n;
    my $l = join '', @l[0..4];

    $s += $i if $c eq $c eq $l;
}

print "Sum: $s\n";
