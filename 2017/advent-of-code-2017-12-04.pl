#!/usr/bin/perl
use strict;
my $i = 0;
my $j = 0;

while (<>) {
    chomp;
    my %w;
    map $w{$_}++, split /\s+/;
    $i++ unless grep $_ > 1, values %w;

    my %a;
    map $a{join '', sort split '', $_}++, split /\s+/;
    $j++ unless grep $_ > 1, values %a;
}

print "$i valid unique words.\n";
print "$j valid unique anagrams.\n";
