#!/usr/bin/perl
use strict;

my @n = map 0+$_, <>;
my @l = map [[], $_ * 811589153, []], @n;

for my $i (-1..$#l-1) {
    $l[$i][2] = $l[$i+1];
    $l[$i+1][0] = $l[$i];
}

# print join(', ', map $_->[1], @l), "\n";

for my $m (1..10) {
    print "Mix: $m\n";

    for my $l (@l) {
        my ($b, $o, $f) = @$l;
        my $n = $o;

        if ($n > 0) {
            $n %= $#l;
            ($b->[2], $f->[0]) = ($f, $b);
            $f = $f->[2] for 1..$n;
            $l->[2] = $f;
            $l->[0] = $f->[0];
            $l->[0][2] = $f->[0]= $l;
        } elsif ($n < 0) {
            $n %= -$#l;
            ($b->[2], $f->[0]) = ($f, $b);
            $b = $b->[0] for 1..-$n;
            $l->[0] = $b;
            $l->[2] = $b->[2];
            $l->[2][0] = $b->[2]= $l;
        }

        # print "$o moves $n steps\n";
    }
}


my $l = $l[0];
$l = $l->[2] while $l->[1] != 0;
$l = $l->[2] for 1...1000;
my $n1 = $l->[1];
$l = $l->[2] for 1...1000;
my $n2 = $l->[1];
$l = $l->[2] for 1...1000;
my $n3 = $l->[1];

print "$n1 + $n2 + $n3 = ", $n1 + $n2 + $n3, "\n";
