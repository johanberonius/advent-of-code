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
    my %o;

    my $c = 0;
    rule: for my $r (@r) {
        my ($f, $l) = @$r;
        next rule if !$p{$f} || !$p{$l};
        $o{$f}--;
        $o{$l}++;
        next rule if $p{$f} < $p{$l};
        $c++;
    }
    next update unless $c;

    @p = sort { $o{$a} <=> $o{$b} } @p;
    $s += $p[$i/2];
}

print "Sum of middle page numbers: $s\n";
