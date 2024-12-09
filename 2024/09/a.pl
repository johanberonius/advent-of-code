#!/usr/bin/perl
use strict;

my $s = <>;
chomp $s;
my @n = split '', $s;
my @m;
for my $i (0..$#n) {
    my $l = $n[$i];
    my $f = $i % 2 ? '.' : int $i / 2;
    push @m => ($f) x $l;
}

print @m, "\n";
my $i = 0;
my $s = 0;
for my $f (@m) {
    if ($f eq '.') {
        pop @m while $m[-1] eq '.';
        $f = pop @m;
        print @m, "\n";
    }
    $s += $i * $f;
    $i++;
}

print "Sum: $s\n";
