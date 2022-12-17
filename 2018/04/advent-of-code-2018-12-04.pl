#!/usr/bin/perl
use strict;

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
        $m{$g}{$_}++ for $s..$M-1;
    }
}

($g) = sort { $g{$b} <=> $g{$a} } keys %g;

my ($M) = sort { $m{$g}{$b} <=> $m{$g}{$a} } keys %{$m{$g}};

print "$c log events, guard ID most asleep: $g, at minute: $M, product: ", $g * $M, "\n";
