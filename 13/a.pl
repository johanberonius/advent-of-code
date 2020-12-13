#!/usr/bin/perl
use strict;

my $t = 0+<>;
my @b = grep $_, map 0+$_, split ',', <>;

print "Earliest time of defarture: $t\n";
print "Number of busses: ", 0+@b, "\n";

my %d = map { $_ => $_ - $t % $_ } @b;

for my $b (@b) {
    print "Bus $b:, waiting time: $d{$b}\n";
}

my ($b) = sort { $d{$a} <=> $d{$b} } @b;
print "Earlist bus: $b, waiting time: $d{$b}, product: ", $b * $d{$b} ,"\n";
