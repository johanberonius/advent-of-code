#!/usr/bin/perl
use strict;
use List::Util qw(max);
use List::MoreUtils qw(pairwise);

my $c = 0;
my $x = 0;
my $y = 0;
my $z = 0;
my $d = 0;
my $md = 0;
my %d = (
    nw => [-1,  0,  1],
    n  => [ 0, -1,  1],
    ne => [ 1, -1,  0],
    se => [ 1,  0, -1],
    s  => [ 0,  1, -1],
    sw => [-1,  1,  0],
);
$/ = ',';
while (<>) {
    chomp;
    s/\W+//g;
    $c++;
    $x += $d{$_}[0];
    $y += $d{$_}[1];
    $z += $d{$_}[2];
    $d = max map abs, $x, $y, $z;
    $md = max $md, $d;
}

print "Steps: $c\n";
print "Position: $x, $y, $z\n";
print "Final steps: $d\n";
print "Max steps: $md\n";
