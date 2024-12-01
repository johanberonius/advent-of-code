#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @l;
my %r;
while (<>) {
    /(\d+)\s+(\d+)/ or die;
    push @l => $1;
    $r{$2}++;
}

my $s = 0;
$s += $_ * $r{$_} for @l;

print "Similarity score: $s\n";
