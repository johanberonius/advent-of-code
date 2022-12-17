#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $s = 0;
$/ = '';
while (<>) {
    chomp;
    my ($i, $j) = map eval, split "\n";
    print "$.: $i => $j ";
    if (packetorder($i, $j) < 0) {
        print "in order";

        $s += $.;
    }
    print "\n";
}

print "Sum of the indices: $s\n";

sub packetorder {
    my ($a, $b) = @_;
    return $a <=> $b if !ref $a && !ref $b;
    $a = [$a] if !ref $a;
    $b = [$b] if !ref $b;

    for my $i (0..min $#$a, $#$b) {
        my $o = packetorder($a->[$i], $b->[$i]);
        return $o if $o;
    }

    return @$a <=> @$b;
}
