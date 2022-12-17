#!/usr/bin/perl
use strict;
use List::Util qw(sum reduce);

sub h {
    my @v = (0 .. 255);
    my @l = map ord, split '', shift;
    push @l => (17, 31, 73, 47, 23);
    my $p = 0;
    my $s = 0;

    for (1..64) {
        for my $l (@l) {
            my @r = map $_ % 256, $p .. $p + $l - 1;
            @v[@r] = reverse @v[@r];
            $p += $l + $s++;
        }
    }

    map { reduce {$a ^ $b} @v[$_*16 .. $_*16+15] } 0 .. 15;
}

my $g = 0;
my %g;
my @g;
push @g => [map 0+$_, split '', sprintf '%8.8b'x16, h("ljoxqyyw-$_")] for (0..127);

my $u = 0;
for my $y (0..127) {
    for my $x (0..127) {
        next unless $g[$y][$x];
        $u++;
        next if $g{"$x,$y"};
        $g++;
        r($x, $y);
    }
}

sub r {
    my ($x, $y) = @_;
    return if $x < 0 || $y < 0;
    return unless $g[$y][$x];
    return if $g{"$x,$y"};
    $g{"$x,$y"} = $g;
    r($x - 1, $y);
    r($x + 1, $y);
    r($x, $y - 1);
    r($x, $y + 1);
}

print "Used squares: $u\n";
print "Groups: $g\n";
