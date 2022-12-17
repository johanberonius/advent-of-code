#!/usr/bin/perl
use strict;
use List::Util qw(all);

my ($c, %d, %s);
while (<>) {
    $c++;
    /step\s+(\w+).*before.*step\s+(\w+)/i;
    push @{$d{$2}} => $1;
    $d{$1} ||= [];
}

print "$c rules\n";

my $r;
do {
    for my $s (keys %d) {
        $s{$s} ||= 'ready' if all { $s{$_} eq 'done' } @{$d{$s}};
    }

    ($r) = sort grep $s{$_} eq 'ready', keys %s;
    $s{$r} = 'done';
    print $r;
} while ($r);

print "\n";