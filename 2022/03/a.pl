#!/usr/bin/perl
use strict;

my $t = 0;
while (<>) {
    chomp;
    my @i = split '';
    my %c = map { $_ => 1 } @i[0..@i/2-1];
    my %d = map { $_ => 1 } @i[@i/2..$#i];

    for (keys %d) {
        if ($c{$_}) {
            my $s;
            if ($_ eq lc $_) {
                $s = ord($_) - ord('a') + 1;
            } else {
                $s = ord($_) - ord('A') + 27;
            }
            $t += $s;
            print "Duplicate item: $_, priority: $s\n";
        }
    }
}
print "Total priority: $t\n";
