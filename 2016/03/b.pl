#!/usr/bin/perl
use strict;

my $n = 0;
my $i = 0;
while (<>) {
    my ($a, $x, $k) = /(\d+)\s+(\d+)\s+(\d+)/ or die $_;
    my ($b, $y, $l) = <> =~ /(\d+)\s+(\d+)\s+(\d+)/ or die $_;
    my ($c, $z, $m) = <> =~ /(\d+)\s+(\d+)\s+(\d+)/ or die $_;

    $n++;
    $i += tri($a, $b, $c);
    $n++;
    $i += tri($x, $y, $z);
    $n++;
    $i += tri($k, $l, $m);
}

print "Triangles: $n\n";
print "Impossible: $i\n";
print "Possible: ", $n-$i, "\n";

sub tri {
    my ($a, $b, $c) = @_;

    print "$a -> $b -> $c ";
    if ($a + $b <= $c || $b + $c <= $a || $c + $a <= $b) {
        print " impossible\n";
        return 1;
    }

    print "\n";
    return 0;
}
