#!/usr/bin/perl
use strict;

my @n = map 0+$_, <>;
my %s = ();
for my $n (@n) {
    my $p = $n % 10;
    my @d = ();
    my %p = ();
    for (1..2000) {
        $n ^= $n * 64;
        $n %= 16777216;

        $n ^= int $n / 32;
        $n %= 16777216;

        $n ^= $n * 2048;
        $n %= 16777216;

        my $s = $n % 10;
        my $d = $s - $p;
        $p = $s;
        push @d => $d;
        shift @d if @d > 4;
        $p{"@d"} = $s unless exists $p{"@d"};
    }

    $s{$_} += $p{$_} for keys %p;
}

my ($k) = sort { $s{$b} <=> $s{$a} } keys %s;
print "Sequence: $k, best price: $s{$k}\n",
