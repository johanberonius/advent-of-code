#!/usr/bin/perl
use strict;
use POSIX qw(ceil);

my $n = 33_100_000;

my $h = 785_820;
my $p;

while (1) {
    $h++;
    # print "$h: ";

    $p = 0;
    for my $e (ceil($h/50)..$h) {
        $p += 11 * $e * !($h % $e);
        # print !($h % $e) ? "$e " : '';
    }
    # print "\n";
    print "House $h got $p presents.\n" unless $h % 1_000;

    last if $p >= $n;
}

print "House $h got $p presents.\n";
