#!/usr/bin/perl
use strict;
use List::Util qw(uniq);

my $c = 0;
my $t = 0;
my %i;
while (<>) {
    chomp;
    $i{$_}++ for uniq split '';

    if ($c % 3 == 2) {
        my @b = grep $i{$_} >= 3, keys %i;
        my $b = $b[0];
        my $s;
        if ($b eq lc $b) {
            $s = ord($b) - ord('a') + 1;
        } else {
            $s = ord($b) - ord('A') + 27;
        }
        $t += $s;
        print "Items carried by all in group: @b, priorty: $s\n";

        %i = ();
    }

    $c++;
}
print "Total priority: $t\n";
