#!/usr/bin/perl
use strict;
use List::Util qw(max);

my ($c, @l, %g, %m, $g, $s);

while (<>) {
    $c++;
    push @l => [/\[(\d+)-(\d+)-(\d+)\s+(\d+):(\d+)/, /(\d+)\s+begin/, /(sleep)/, /(wake)/];
}

@l = sort { "@$a" cmp "@$b" } @l;

foreach (@l) {
    my ($y, $m, $d, $H, $M, $e) = @$_;

    if ($e > 0) {
        $g = $e;
    } elsif ($e eq 'sleep') {
        $s = $M;
    } elsif ($e eq 'wake') {
        $g{$g} += $M - $s;
        $m{$_}{$g}++ for $s..$M-1;
    }
}

my ($M) = sort { max(values %{$m{$b}}) <=> max(values %{$m{$a}}) } keys %m;

($g) = sort { $m{$M}{$b} <=> $m{$M}{$a} } keys %{$m{$M}};

print "$c log events, guard ID most asleep: $g, at minute: $M, product: ", $g * $M, "\n";
