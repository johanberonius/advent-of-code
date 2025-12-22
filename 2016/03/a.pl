#!/usr/bin/perl
use strict;

my $n = 0;
my $i = 0;
while (<>) {
    my ($a, $b, $c) = /(\d+)\s+(\d+)\s+(\d+)/ or die $_;

    print "$a -> $b -> $c ";
    $n++;
    if ($a + $b <= $c || $b + $c <= $a || $c + $a <= $b) {
        print " impossible";
        $i++;
    }

    print "\n";
}

print "Triangles: $n\n";
print "Impossible: $i\n";
print "Possible: ", $n-$i, "\n";
