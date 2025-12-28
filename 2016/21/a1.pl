#!/usr/bin/perl
use strict;

my $p = "abcdefgh";
# my $p = "abcde";

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
        (substr($p, $a, 1), substr($p, $b, 1)) = (substr($p, $b, 1), substr($p, $a, 1));
    } elsif ($i eq 'swl') {
        eval qq(\$p =~ tr/$a$b/$b$a/);
    } elsif ($i eq 'rol') {
        $a %= length $p;
        $p =~ s/(.{$a})(.*)/$2$1/;
    } elsif ($i eq 'ror') {
        $a %= length $p;
        $p =~ s/(.*)(.{$a})/$2$1/;
    } elsif ($i eq 'rop') {
        my $i = index $p, $a;
        $i++ if $i >= 4;
        $i++;
        $i %= length $p;
        $p =~ s/(.*)(.{$i})/$2$1/;
    } elsif ($i eq 'rev') {
        my $s = substr $p, $a, $b-$a+1;
        substr $p, $a, $b-$a+1, reverse $s;
    } elsif ($i eq 'mov') {
        my $s = substr $p, $a, 1, '';
        my $l = substr $p, $b, 1;
        substr $p, $b, 1, "$s$l";
    } else {
        die $i;
    }

    print "$p\n";
}