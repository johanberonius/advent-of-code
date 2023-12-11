#!/usr/bin/perl
use strict;
use List::Util qw(notall);

my $s = 0;
while (<>) {
    my @s;
    my @n = map 0+$_, split ' ';
    print "n: @n\n";

    while (notall { $_ == 0 } @n) {
        push @s => [@n];
        @n = map $n[$_+1] - $n[$_], 0..$#n-1;
        print "n: @n\n";
    }

    my $d = 0;
    while (@s) {
        @n = @{pop @s};
        $d = $n[-1] + $d;
        print "n: @n $d\n";
    }

    $s += $d;
}

print "Sum: $s\n";
