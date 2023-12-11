#!/usr/bin/perl
use strict;
use Math::Utils qw(lcm);

my @q = <> =~ /\w/g;

my %n;
while (<>) {
    $n{$1} = { L => $2, R => $3 } if /(\w+) = \((\w+), (\w+)\)/;
}

my @n = grep /A$/, sort keys %n;

print "Starting nodes: ", 0+@n, ", @n\n";

my @c;
for my $n (@n) {

    my $s = 0;

    print "Start node: $n\n";

    while (1) {
        if ($n =~ /Z$/) {
            print "End node: $n after $s steps\n";
            push @c => $s;
            last;
        }

        my $t = $q[$s % @q];
        $n = $n{$n}{$t};
        $s++;
    }

    print "\n";
}

my $lcm = lcm(@c);
print "All end nodes after $lcm steps.\n";
