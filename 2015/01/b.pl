#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %c = ('(' => 1, ')' => -1);
my $s = 0;
my $i = 0;
for my $c (split '', <>) {
    $i++;
    last if ($s += $c{$c}) < 0;
}

print "$i\n";
