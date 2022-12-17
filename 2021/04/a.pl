#!/usr/bin/perl
use strict;
use List::Util qw(all sum);

my ($n, @b) = split '\n\n', join '', <>;

my @n = map 0+$_, split ',', $n;
print "Numbers: ", 0+@n, "\n";

$_ = [map [map 0+$_, /(\d+)/g], split '\n'] for @b;

number: for my $n (@n) {
    print "Draw number: $n\n";

    for my $b (@b) {
        for my $r (@$b) {
            $r = [map $_ == $n ? 'x' : $_, @$r];
        }

        my $bingo = 0;
        for my $r (@$b) {
            $bingo = 'row' if all {/x/} @$r;
        }
        for my $i (0..4) {
            my @c = map $_->[$i], @$b;
            $bingo = 'column' if all {/x/} @c;
        }
        if ($bingo) {
            print "Bingo in $bingo on board\n";

            my $s = sum map { sum @$_ } @$b;
            print "Sum of unmarked numbers: $s\n";
            print "Filnal score: ", $s * $n, "\n";

            last number;
        }
    }
}
