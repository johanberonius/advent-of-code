#!/usr/bin/perl
use strict;
use List::Util qw(sum all);

my %r;
my %v;
my ($b, $l);
my ($s, $v, $w, $m, $n);
my $p = 0;
my $c = 0;

while (<>) {
    $b = $1 if /begin.*state.*([A-Z])/i;
    $l = $1 if /checksum.*after.*?(\d+).*steps/i;
    $s = $1 if /in\s+state.*([A-Z])/i;
    $v = $1 if /current\s+value.*(\d)/i;
    $w = 0+$1 if /write.*value.*(\d)/i;
    $m = $1 eq 'left' ? -1 : 1 if /move\s+one\s+slot.*(left|right)/i;
    $n = $1 if /continue.*state.*([A-Z])/i;

    if (all { $_ gt '' } $s, $v, $w, $m, $n) {
        $r{"$s,$v"} = [$w, $m, $n];
        ($w, $m, $n) = ();
    }
}

print "Running $l steps.\n";

while (++$c <= $l) {
    my $v = $v{$p} || 0;
    my $a = $r{"$b,$v"};
    $v{$p} = $a->[0];
    $p += $a->[1];
    $b = $a->[2];
}

print "Checksum: ", sum(values %v), "\n";
