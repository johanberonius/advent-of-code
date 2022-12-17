#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @s = split '', <>;
my $s = @s;
print "Stream length: $s\n";

my $w = 25;
my $h = 6;
my $l = $w * $h;
print "Image layer size: $l\n";

my $n = int $s / $l;
print "Image layers: $n\n";

my %c;
for my $z (0..$n-1) {
    for my $y (0..$h-1) {
        for my $x (0..$w-1) {
            my $p = shift @s;
            $c{$z}{$p}++;
        }
    }
}

my ($k) = sort { $c{$a}{0} <=> $c{$b}{0} } keys %c;
print "Layer with fewest zeros: $k\n";

print "Product of ones and twos: ", $c{$k}{1} * $c{$k}{2}, "\n";
