#!/usr/bin/perl
use strict;

my $i = 0;
my $p;

my @n = map 0+$_, <>;
print "Numbers: ", 0+@n, "\n";

for (@n) {
    $i += $p && $p < $_;
    $p = $_;
}

print "Increases: $i\n";
