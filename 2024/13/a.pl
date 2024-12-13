#!/usr/bin/perl
use strict;
use List::Util qw(min);

my ($ax, $ay);
my ($bx, $by);
my ($px, $py);
my $t = 0;

while (<>) {
    if (/Button A: X\+(\d+), Y\+(\d+)/) {
        ($ax, $ay) = ($1, $2);
    } elsif (/Button B: X\+(\d+), Y\+(\d+)/) {
        ($bx, $by) = ($1, $2);
    } elsif (/Prize: X=(\d+), Y=(\d+)/) {
        ($px, $py) = ($1, $2);

        print "($ax, $ay) ($bx, $by) ($px, $py)\n";
        my @w = ();
        for my $a (0..100) {
            for my $b (0..100) {
                if ($a * $ax + $b * $bx == $px && $a * $ay + $b * $by == $py) {
                    push @w => $a * 3 + $b;
                }
            }
        }
        my $w = min @w;
        print "Win: $w\n";
        $t += $w;
    }
}

print "Tokens: $t\n";
