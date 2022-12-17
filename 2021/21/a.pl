#!/usr/bin/perl
use strict;
use List::Util qw(min);

my @p;
($p[0]) = <> =~ /Player 1.+position:\s*(\d+)/ or die;
($p[1]) = <> =~ /Player 2.+position:\s*(\d+)/ or die;

print "Player 1 starting position: $p[0]\n";
print "Player 2 starting position: $p[1]\n";

my @s = (0, 0);
my $t = 0;
my $d = 1;
while (1) {

    my @r = ($d++, $d++, $d++);
    my $r = $r[0] + $r[1] + $r[2];

    $p[$t] = ($p[$t] + $r) % 10 || 10;
    $s[$t] += $p[$t];

    print "Player ", $t+1, " rolls ", join('+', @r), " and moves to space $p[$t] for a total score of $s[$t].\n";

    last if $s[$t] >= 1000;

    $t = !$t;
}

print "Losing score: ", min(@s), "\n";
print "Times die rolled: ", --$d, "\n";
print "Product: ", min(@s) * $d, "\n";
