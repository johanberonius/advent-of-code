#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %m;
my ($m1, $m2, $x, $l, @m);
while (<>) {
    if (/mask\s+=\s+([X01]+)/i) {
        $m1 = $m2 = $1;
        $m1 =~ tr/X01/100/;
        @m = split '', $m1;
        $m2 =~ tr/X01/001/;
        $x = $m1;
        $x =~ s/0//g;
        $l = length $x;
        $m1 = eval("0b$m1");
        $m2 = eval("0b$m2");
        $x = eval("0b$x");
    } elsif (/mem\[(\d+)\]\s+=\s+(\d+)/) {
        my ($a, $v) = (0+$1, 0+$2);

        for my $b (0..$x) {
            my @b = split '', sprintf "%.${l}b", $b;
            my $f = '';
            for my $m (@m) {
                $f .= !$m ? $m : shift @b;
            }
            $f = eval("0b$f");

            my $t = $a & ~$m1 | $f | $m2;
            $m{$t} = $v;
        }
    }
}

print "Sum of memory values: ", sum(values %m), "\n";
