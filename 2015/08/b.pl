#!/usr/bin/perl
use strict;


my $c = 0;
my $l = 0;
while (<>) {
    chomp;
    print;
    print " ", length();
    $l += length;

    s/\\/\\\\/g;
    s/"/\\"/g;
    $_ = "\"$_\"";

    print " $_ ", length(), "\n";
    $c += length;
}

print "Length: $l\n";
print "Chars: $c\n";
print "Diff: ", $c - $l, "\n";
