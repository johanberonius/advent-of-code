#!/usr/bin/perl
use strict;
use Math::Utils qw(sign);

my $c = 0;
report: while (<>) {
    my @m = split ' ';
    print "@m\n";

    exclude: for my $x (0..$#m) {
        my @n = @m;
        splice @n, $x, 1;
        print "   $x: @n";

        my $s = sign $n[1] - $n[0];
        for my $i (0..$#n-1) {
            my $d = ($n[$i+1] - $n[$i]) * $s;
            next exclude if $d < 1 || $d > 3;
        }

        $c++;
        print " - safe\n";
        next report;
    } continue {
        print "\n";
    }
}

print "$c reports are safe.\n";
