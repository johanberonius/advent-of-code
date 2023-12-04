#!/usr/bin/perl
use strict;

my $sum = 0;
while (<>) {
    /Card\s+(\d+): (.+) \| (.+)/ or die "Unrecognized input: $_";
    my $card = $1;
    my %win = map { 0+$_ => 1 } split " ", $2;
    my %num = map { 0+$_ => 1 } split " ", $3;
    my $wins = grep $win{$_}, keys %num;
    my $points = $wins ? 2 ** ($wins -1): 0;
    print "Card $card scores $points\n";
    $sum += $points;
}

print "Sum: $sum\n";
