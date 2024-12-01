#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @l;
my @r;
while (<>) {
    /(\d+)\s+(\d+)/ or die;
    push @l => $1;
    push @r => $2;
}

@l = sort $a <=> $b, @l;
@r = sort $a <=> $b, @r;

print "@l\n";
print "@r\n";

my @d = map abs($l[$_] - $r[$_]), 0..$#l;
print "@d\n";

print "Total distance: ", sum(@d), "\n";
