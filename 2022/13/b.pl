#!/usr/bin/perl
use strict;
use List::Util qw(min product);

my $divider1 = [[2]];
my $divider2 = [[6]];
my @packets = sort { packetorder($a, $b) } $divider1, $divider2, map eval, <>;
my $key = product grep { $packets[$_-1] == $divider1 || $packets[$_-1] == $divider2 } 1..@packets;
print "Decoder key: $key\n";

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
