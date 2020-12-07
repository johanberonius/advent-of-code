#!/usr/bin/perl
use strict;

my %c;
my $i = 0;
while (<>) {
    my ($c, $o) = split /\s+bags\s+contain\s+/;

    for (split /,\s+/, $o) {
        push @{$c{$2}} => $c if /(\d+)\s+(\w+\s+\w+)/;
    }
    $i++;
}

print "Number of bag colors: $i\n";

my $s = 'shiny gold';
my @c = ($s);
my %p;
while (my $c = shift @c) {
    for my $p (@{$c{$c}}) {
        $p{$p}++;
        push @c => $p;
    }
}

print "$s can be contained in ", 0+keys %p, " other colors of bags.\n";
