#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $t;
while (<>) {
    if (/^(\w+)$/) {
        $t = $1;
    }
}

my @e = $t =~ /([A-Z][a-z]?)/g;

my $l = length $t;
print "Length: $l\n";

my $e = @e;
print "Elements: $e\n";

my $ra = grep /Rn|Ar/, @e;
print "Rn or Ar: $ra\n";

my $y = grep /Y/, @e;
print "Y: $y\n";

my $s = $e - $ra - 2 * $y - 1;
print "Steps: $s\n";
