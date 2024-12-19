#!/usr/bin/perl
use strict;

$_ = <>;
chomp;
my @t = split /\s*,\s*/;
my @d = map { chomp; $_ || () } <>;

print "Towels: ", 0+@t, "\n";
print "Designs: ", 0+@d, "\n";

my $re = join '|', @t;
my $c = 0;
for (@d) {
    $c++ if /^($re)+$/;
}

print "Possible designs: $c\n";
