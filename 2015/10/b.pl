#!/usr/bin/perl
use strict;

my $d = "1113122113";
print "$d ", length($d), "\n";

for (1..50) {
    $d =~ s/((\d)\2*)/length($1) . $2/eg;
}

print "Length: ", length($d), "\n";
