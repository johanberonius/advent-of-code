#!/usr/bin/perl
use strict;

my @r;
while(<>) {
    chomp;
    last unless $_;
    push @r => [split '\|'];
}

my $s = 0;
update: while(<>) {
    chomp;
    my $i = 0;
    my @p = split ',';
    my %p = map { $_ => ++$i } @p;

    rule: for my $r (@r) {
        my ($f, $l) = @$r;
        next rule if !$p{$f} || !$p{$l};
        next update if $p{$f} > $p{$l};
    }
    $s += $p[$i/2];
}

print "Sum of middle page numbers: $s\n";
