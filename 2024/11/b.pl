#!/usr/bin/perl
use strict;

my @n = split ' ', <>;

my $c = 0;
$c += blink($_, 0) for @n;

print "Stones: $c\n";

my %m;
sub blink {
    my $n = shift;
    my $d = shift;
    my $l = length $n;
    if ($m{"$n,$d"}) {
        $m{"$n,$d"};
    } elsif ($d >= 75) {
        $m{"$n,$d"} = 1
    } elsif ($n == 0) {
        $m{"$n,$d"} = blink(1, $d+1);
    } elsif($l % 2 == 0) {
        $m{"$n,$d"} = blink(0+substr($n, 0, $l/2), $d+1) + blink(0+substr($n, $l/2), $d+1);
    } else {
        $m{"$n,$d"} = blink($n * 2024, $d+1);
    }
}
