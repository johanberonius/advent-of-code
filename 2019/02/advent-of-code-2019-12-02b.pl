#!/usr/bin/perl
use strict;

my @m = map 0+$_, split ',', <>;


N: for my $n (0..99) {
    V: for my $v (0..99) {
        my @p = @m;
        my $pc = 0;

        print "Testing $n, $v: ";

        $p[1] = $n;
        $p[2] = $v;

        while (1) {
            die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

            my $i = $p[$pc];

            if ($i == 1) {
                my $a = $p[++$pc];
                my $b = $p[++$pc];
                my $c = $p[++$pc];
                $p[$c] = $p[$a] + $p[$b];
            } elsif ($i == 2) {
                my $a = $p[++$pc];
                my $b = $p[++$pc];
                my $c = $p[++$pc];
                $p[$c] = $p[$a] * $p[$b];
            } elsif ($i == 99) {
                last;
            } else {
                die "Unknown inctruction: $i";
            }

            $pc++;
        }

        my $o = $p[0];

        print "output: $o\n";

        last N if $o == 19690720;
    }
}
