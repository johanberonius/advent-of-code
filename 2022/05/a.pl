#!/usr/bin/perl
use strict;

my @s;
my $s = 0;
while (<>) {
    chomp;
    s/\s+$//;
    last unless $_;
    $s[$s++] = [split ''];
}

while (<>) {
    /move (\d+) from (\d+) to (\d+)/;
    push @{$s[$3-1]} => pop @{$s[$2-1]} for (1..$1);
}

print pop @{$s[$_]} for (0..$s-1);
print "\n";
