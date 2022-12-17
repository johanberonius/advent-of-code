#!/usr/bin/perl
use strict;

my ($a, $b, $c);
while (<>) {
    $c++;
    my %c;
    $c{$_}++ for split '';
    $a++ if grep $_ == 2, values %c;
    $b++ if grep $_ == 3, values %c;
}

print "$c box IDs, $a contains a letter twice, $b contains a letter trice, checksum: ", $a * $b, "\n";
