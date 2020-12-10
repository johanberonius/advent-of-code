#!/usr/bin/perl
use strict;

my @n = sort { $a <=> $b } map 0+$_, <>;
print "Number of joltage adapters: ", 0+@n, "\n";

unshift @n => 0;
push @n => $n[-1] + 3;
print "Device joltage: $n[-1]\n";

my @s = (1);
for my $i (1..$#n) {
    my $c = grep $_ >= $n[$i] - 3 && $_ <= $n[$i] - 1, @n;
    $s[$i] += $s[$i-$_] for (1..$c);
    print "$n[$i] can connect to $c nodes, $s[$i] combinations.\n";
}

print "$s[-1] combinations.\n";
