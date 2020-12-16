#!/usr/bin/perl
use strict;
use List::Util qw(sum any);

my @n;
my @r;
while (<>) {
    if (1../^$/) {
        push @r => [map 0+$_, $1, $2, $3, $4] if /(\d+)-(\d+)\s+or\s+(\d+)-(\d+)/g;
    } elsif (/nearby tickets/..1) {
        push @n => map 0+$_, split ',' if /\d+/;
    }

}

print "Number of rules: ", 0+@r, "\n";
print "Numbers: ", 0+@n, "\n";

my @i = grep {
    my $n = $_;
    not any {
        $n >= $_->[0] && $n <= $_->[1]
        or
        $n >= $_->[2] && $n <= $_->[3]
    } @r;
} @n;

my $s = sum @i;

print "Invalid numbers: @i, sum: $s\n";
