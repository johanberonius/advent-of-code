#!/usr/bin/perl
use strict;


my %u;
my %a;
while (<>) {
    my ($x, $y, $s, $u, $a, $p) = /node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T\s+(\d+)%/ or next;

    $u{"$x,$y"} = 0+$u;
    $a{"$x,$y"} = 0+$a;
}

my $c = 0;
for my $a (keys %a) {
    for my $b (keys %a) {
        next if $u{$a} == 0;
        next if $a eq $b;
        $c++ if $u{$a} <= $a{$b};
    }
}

print "Viable pairs: $c\n";
