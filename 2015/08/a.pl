#!/usr/bin/perl
use strict;


my $c = 0;
my $l = 0;
while (<>) {
    chomp;
    print;
    print " ", length();
    $l += length;

    s/^"|"$//g;
    s/\\([\\"])/$1/g;
    s/\\x([0-9a-fA-F]{2})/chr(eval "0x$1")/eg;

    print " $_ ", length(), "\n";
    $c += length;
}

print "Length: $l\n";
print "Chars: $c\n";
print "Diff: ", $l - $c, "\n";
