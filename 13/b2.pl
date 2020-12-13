#!/usr/bin/perl
use strict;
use Math::Utils qw(lcm);

my $t = <>;
my $o = 0;
my @b;
my %b;
for (split ',', <>) {
    my $n = 0+$_;
    if ($n) {
        push @b => $n;
        $b{$n} = $o;
    }
    $o++;
}

print "Number of busses: ", 0+@b, "\n";

my %p = ($b[0] => 1);
my $n = 0;
l: while (1) {
    $n += lcm keys %p;
    for my $b (@b) {
        next l unless ($n + $b{$b}) % $b == 0;
        $p{$b} = 1;
    }
    last;
}

print "Earliest sequential bus departure time: $n\n";
