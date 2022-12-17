#!/usr/bin/perl
use strict;
use List::Util qw(max);

my %v;
my %d = (inc => 1, dec => -1);
my $n = 0;

while (<>) {
    chomp;
    my ($r, $d, $v, $c, $cr, $cb, $cv) = split /\s+/;
    $v{$cr} ||= 0;
    $v{$r} += $d{$d} * $v if eval "$v{$cr} $cb $cv";
    $n = max $n, values %v;
}

my $m = max values %v;
print "Max seen register value: $n\n";
print "Max final register value: $m\n";
