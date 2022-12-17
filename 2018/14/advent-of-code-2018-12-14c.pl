#!/usr/bin/perl
use strict;

my $s = '37';
my $c1 = 0;
my $c2 = 1;

# my $r = '01245';
# my $r = '51589';
# my $r = '92510';
# my $r = '59414';
my $r = '047801';
my $rl = -length($r) - 1;

while (index(substr($s, $rl), $r) == -1) {

    my $s1 = substr $s, $c1, 1;
    my $s2 = substr $s, $c2, 1;
    $s .= $s1 + $s2;
    my $sl = length $s;
    $c1 = ($c1 + 1 + $s1) % $sl;
    $c2 = ($c2 + 1 + $s2) % $sl;
}

print "Number of recipies before '", substr($s, $rl), "': ", index($s, $r), "\n";
