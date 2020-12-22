#!/usr/bin/perl
use strict;
use List::Util qw(sum);


my @p1;
my @p2;
while (<>) {
    if (/Player 1/i../^$/) {
        push @p1 => 0+$1 if /^(\d+)$/;
    } elsif (/Player 2/i../^$/) {
        push @p2 => 0+$1 if /^(\d+)$/;
    }
}

print "Player 1 cards: ", 0+@p1, " (@p1)\n";
print "Player 2 cards: ", 0+@p2, " (@p2)\n";

my $r = 0;
while (@p1 and @p2) {
    $r++;

    my $p1 = shift @p1;
    my $p2 = shift @p2;
    if ($p1 > $p2) {
        push @p1 => ($p1, $p2);
    } elsif ($p2 > $p1) {
        push @p2 => ($p2, $p1);
    } else {
        die "Unexpected draw";
    }
}

print "Game ended after $r rounds.\n";
print "Player 1 score: ", sum(map((@p1-$_) * $p1[$_], 0..$#p1)), "\n";
print "Player 2 score: ", sum(map((@p2-$_) * $p2[$_], 0..$#p2)), "\n";
