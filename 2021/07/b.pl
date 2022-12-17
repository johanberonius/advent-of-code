#!/usr/bin/perl
use strict;
use List::Util qw(sum min max);

my @n = map 0+$_, split ',', <>;

print "Number of crab submarines: ", 0+@n, "\n";
print "Horizontal positions: ", join(',', @n), "\n";
print "Average position: ", sum(@n)/@n, "\n";

my %f;
my %s;
for my $p (min(@n)..max(@n)) {
    my $f = sum map {$s{$_} ||= sum 0..$_} map {abs $_-$p} @n;
    $f{$p} = $f;
    print "Position: $p, fuel: $f\n";
}

my ($p) = sort { $f{$a} <=> $f{$b} } keys %f;
print "Lowest fuel consumption at position $p is $f{$p}\n";
