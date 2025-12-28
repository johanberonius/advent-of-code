#!/usr/bin/perl
use strict;

my @p = qw(a b c d e f g h);
# my @p = qw(a b c d e);

my @i;
while (<>) {
    if (/swap position (\d+) with position (\d+)/) {
        push @i => ['swp', $1, $2];
    } elsif (/swap letter (\w) with letter (\w)/) {
        push @i => ['swl', $1, $2];
    } elsif (/rotate left (\d+) step/) {
        push @i => ['rol', $1];
    } elsif (/rotate right (\d+) step/) {
        push @i => ['ror', $1];
    } elsif (/rotate based on position of letter (\w)/) {
        push @i => ['rop', $1];
    } elsif (/reverse positions (\d+) through (\d+)/) {
        push @i => ['rev', $1, $2];
    } elsif (/move position (\d+) to position (\d+)/) {
        push @i => ['mov', $1, $2];
    } else {
        die $_;
    }
}

for (@i) {
    my ($i, $a, $b) = @$_;

    if ($i eq 'swp') {
        @p[$a, $b] = @p[$b, $a];
    } elsif ($i eq 'swl') {
        s/$a/$b/ || s/$b/$a/ for @p;
    } elsif ($i eq 'rol') {
        @p = @p[$a..$#p, 0..$a-1];
    } elsif ($i eq 'ror') {
        @p = @p[@p-$a..$#p, 0..@p-$a-1];
    } elsif ($i eq 'rop') {
        my ($i) = grep $p[$_] eq $a, 0..$#p;
        $i++ if $i >= 4;
        $i++;
        $i %= @p;
        @p = @p[@p-$i..$#p, 0..@p-$i-1];
    } elsif ($i eq 'rev') {
        @p[$a..$b] = reverse @p[$a..$b];
    } elsif ($i eq 'mov') {
        my $l = splice @p, $a, 1;
        splice @p, $b, 0, $l;
    } else {
        die $i;
    }

    print "@p\n";
}
