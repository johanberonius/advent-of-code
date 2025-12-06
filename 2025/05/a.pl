#!/usr/bin/perl
use strict;
use List::Util qw(any);

my @i;
my @r;
while (<>) {
    if (/(\d+)-(\d+)/) {
        push @r => [$1, $2];
    } elsif (/(\d+)/) {
        push @i => $1;
    }
}

print "IDs: ", 0+@i, "\n";
print "Ranges: ", 0+@r, "\n";

my $c = 0;
for my $i (@i) {
    $c++ if any { $i >= $_->[0] && $i <= $_->[1] } @r;
}

print "Fresh IDs: $c\n";
