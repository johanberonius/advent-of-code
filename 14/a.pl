#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %m;
my ($m1, $m2);
while (<>) {
    if (/mask\s+=\s+([X01]+)/i) {
        $m1 = $m2 = $1;
        $m1 =~ tr/X01/100/;
        $m1 = eval("0b$m1");
        $m2 =~ tr/X01/001/;
        $m2 = eval("0b$m2");
    } elsif (/mem\[(\d+)\]\s+=\s+(\d+)/) {
        my ($a, $v) = (0+$1, 0+$2);
        $m{$a} = $v & $m1 | $m2;
    }
}

print "Sum of memory values: ", sum(values %m), "\n";
