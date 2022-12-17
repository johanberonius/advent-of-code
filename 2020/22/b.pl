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
my $w = combat(\@p1, \@p2);

sub combat {
    my $p1 = shift;
    my $p2 = shift;

    my %s;
    while (@$p1 and @$p2) {
        $r++;

        return 1 if $s{"@$p1,@$p2"}++;

        my $c1 = shift @$p1;
        my $c2 = shift @$p2;

        if (@$p1 >= $c1 and @$p2 >= $c2) {
            my @p1 = @$p1[0..$c1-1];
            my @p2 = @$p2[0..$c2-1];

            my $w = combat(\@p1, \@p2);
            if ($w == 1) {
                push @$p1 => ($c1, $c2);
            } elsif ($w == 2) {
                push @$p2 => ($c2, $c1);
            } else {
                die "Unexpected winner";
            }
        } elsif ($c1 > $c2) {
            push @$p1 => ($c1, $c2);
        } elsif ($c2 > $c1) {
            push @$p2 => ($c2, $c1);
        } else {
            die "Unexpected draw";
        }
    }

    return 1 unless @$p2;
    return 2 unless @$p1;
    return 0;
}

print "Game ended after $r rounds, winner is player $w.\n";

print "Player 1 cards: ", 0+@p1, " (@p1)\n";
print "Player 2 cards: ", 0+@p2, " (@p2)\n";

print "Player 1 score: ", sum(map((@p1-$_) * $p1[$_], 0..$#p1)), "\n";
print "Player 2 score: ", sum(map((@p2-$_) * $p2[$_], 0..$#p2)), "\n";
