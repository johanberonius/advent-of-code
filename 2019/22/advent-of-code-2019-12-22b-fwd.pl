#!/usr/bin/perl
use strict;

# my $n = 119_315_717_514_047;
my $n = 10;

my $i = 101_741_582_076_661;

# my $d = 2020;
# my $s = $d;

my @r = <>;

for my $d (0..$n-1) {
    my $c = 0;
    print "$d => ";

    for (@r) {
        chomp;
        print;
        if (/new stack/) {
            $d = $n - 1 - $d;
        } elsif (/cut\s+(-?\d+)/) {
            my $i = 0+$1;
            if ($i > 0) {
                $d += $i;
                $d -= $n if $d >= $n;
            } elsif ($i < 0) {
                $d -= $i;
                $d += $n if $d < 0;
            } else {
                die "Cut by zero";
            }
        } elsif (/increment\s+(\d+)/) {
            my $i = 0+$1;

print " => ";
print 'int($d / $i): ', int($d / $i), ', ';
print '$d % $i: ', $d % $i, ', ';
print 'int($n / $i): ', int($n / $i), ', ';
print '$n % $i: ', $n % $i, ', ';

print " => $d"

        } else {
            die "Unrecognized rule: $_";
        }
    }

    print "\n";
}
print "\n";
