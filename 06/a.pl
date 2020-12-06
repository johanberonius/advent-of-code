#!/usr/bin/perl
use strict;

my @g = split /\s*\n\s*\n\s*/, join '', <>;

print "Number of groups: ", 0+@g, "\n";

my $s = 0;
for my $g (@g) {
    my %g = map { $_ => 1 } split /\s*/, $g;
    my $q = 0 + keys %g;
    print "Unique questions in group: $q\n";
    $s += $q;
}

print "Sum of questions per group: $s\n";
