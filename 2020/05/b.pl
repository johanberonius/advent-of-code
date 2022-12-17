#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my %ids = map { tr/FBLR/0101/; eval("0b$_") => 1 } <>;
my $min = min(keys %ids);
my $max = max(keys %ids);

print "Lowest boarding pass id: $min\n";
print "Highest boarding pass id: $max\n";
print map "Unoccupied boarding pass id: $_\n", grep !$ids{$_}, $min..$max;
