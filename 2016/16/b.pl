#!/usr/bin/perl
use strict;

my $a = "10011111011011001";
my $l = 35_651_584;

while (length($a) < $l) {
    my $b = reverse $a;
    $b =~ tr/01/10/;
    $a .= '0';
    $a .= $b;
}

# print "$a\n";
print "Length: ", length($a), "\n";

$a = substr $a, 0, $l;

# print "$a\n";
print "Length: ", length($a), "\n";

$a =~ s/([01])([01])/$1 eq $2 ? '1' : '0'/eg while length($a) % 2 == 0;

print "Checksum: $a\n";
