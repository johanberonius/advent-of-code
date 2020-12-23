#!/usr/bin/perl
use strict;

# my $n = 389125467;
my $n = 123487596;

my @n = map 0+$_, split '', $n;


my $s = 3;
my $c = 0;
for my $i (1..100) {
    print "-- move $i --\n";
    print "cups: ", join(' ', map { $_ == $c ? "($n[$_])" : $n[$_]} 0..$#n), "\n";

    my @r = splice @n, $c+1, $s;
    if (@r < $s) {
        $c -= $s - @r;
        push @r => splice @n, 0, $s - @r;
    }
    print "pick up: ", join(', ', @r), "\n";

    my ($d) = sort {
        $n[$b] < $n[$c] <=> $n[$a] < $n[$c] ||
        $n[$b] <=> $n[$a]
    } 0..$#n;
    print "destination: $n[$d]\n";
    print "\n";

    splice @n, $d+1, 0, @r;
    $c += $s if $d < $c;

    $c++;
    $c %= @n;
}

print "-- final --\n";
print "cups: ", join(' ', map { $_ == $c ? "($n[$_])" : $n[$_]} 0..$#n), "\n";

my ($o) = grep $n[$_] == 1, 0..$#n;
print "labels: ", @n[map $_ % @n, $o+1..$o+$#n], "\n";
