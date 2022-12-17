#!/usr/bin/perl
use strict;

my $m = 119_315_717_514_047;
my $n = 101_741_582_076_661;
my $d = 2020;

my $k = 1;
my $b = 0;

while (<>) {
    if (/new stack/) {
        $k = add(0, -$k);
        $b = add(-1, -$b);
    } elsif (/cut\s+(-?\d+)/) {
        $b = add($b, -$1);
    } elsif (/increment\s+(\d+)/) {
        $k = mul($k, $1);
        $b = mul($b, $1);
    }
}

my $x = mul($b, pow($k-1, $m-2));
my $r = add(mul(add($x, $d), pow(pow($k, $m-2), $n)), -$x);

print "Result: $r\n";


sub combine {
    my ($f, $u, $a, $b) = @_;
    while(1) {
        return $u if !$b;
        $u = $f->($u, $a) if $b & 1;
        $b >>= 1;
        $a = $f->($a, $a);
    }
}

sub add {
    my ($a, $b) = @_;
    ($m + ($a + $b) % $m) % $m;
}

sub mul {
    my ($a, $b) = @_;
    combine(\&add, 0, $a, $b);
}

sub pow {
    my ($a, $b) = @_;
    combine(\&mul, 1, $a, $b);
}
