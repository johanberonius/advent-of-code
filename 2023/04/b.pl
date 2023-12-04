#!/usr/bin/perl
use strict;

my $cards = 0;
my @copies;
while (<>) {
    /Card\s+(\d+): (.+) \| (.+)/ or die "Unrecognized input: $_";
    my $copies = 1 + shift @copies;
    my $card = $1;
    my %win = map { 0+$_ => 1 } split " ", $2;
    my %num = map { 0+$_ => 1 } split " ", $3;
    my $wins = grep $win{$_}, keys %num;
    $copies[$_] += $copies for 0..$wins-1;
    $cards += $copies;
    print "$copies copies of card $card wins $wins more cards. Count $cards. @copies \n";
}

print "Cards: $cards\n";
