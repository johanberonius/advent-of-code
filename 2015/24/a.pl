#!/usr/bin/perl
use strict;
use List::Util qw(product sum min);

my @w = map 0+$_, <>;
my $t = sum @w;
my $g = $t / 3;

print "Packages: ", 0+@w, "\n";
print "Weights: @w\n";
print "Total weight: $t\n";
print "Group weight: $g\n";
print "5 heaviest weight: ", sum(@w[-5..-1]),"\n";

my $r = $t;
my @q = ([]);
for my $w (sort { $b <=> $a } @w) {
    print "w: $w, q: ", 0+@q, "\n";

    $r -= $w;

    @q = grep {
        my $s = sum @$_;
        $s <= $g && $s + $r >= $g
    } map {
        [@$_, $w],
        $_,
    } @q;
}

print "Possible groups: ", 0+@q, "\n";

@q = sort { @$a <=> @$b } @q;

print "Smallest group size: ", 0+@{$q[0]}, "\n";

@q = grep { @$_ == @{$q[0]} } @q;

print "Smallest groups: ", 0+@q, "\n";

my $m = min map product(@$_), @q;

print "Minimum product: $m\n";
