#!/usr/bin/perl
use strict;


my %t = (
    "=" => -2,
    "-" => -1,
    0 => 0,
    1 => 1,
    2 => 2,
);

my %r = map { $t{$_} => $_ } keys %t;

my @s;
while (<>) {
    chomp;
    my @n = reverse split '';
    $s[$_] += $t{$n[$_]} for 0..$#n;

    print "Add: $_, \t sum: ", join(' ', reverse @s), "\n";
}

for my $i (0..$#s) {
    while ($s[$i] > 2) {
        $s[$i] -= 5;
        $s[$i+1]++;
    }

    while ($s[$i] < -2) {
        $s[$i] += 5;
        $s[$i+1]--;
    }
}

print "Sum: ", map($r{$_}, reverse @s), "\n";
