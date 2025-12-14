#!/usr/bin/perl
use strict;
use List::Util qw(any);

$_ = $ARGV[0];
my @c = map { split ',' } /{(.*?)}/;
my @b = map [split ','], /\((.*?)\)/g;


for my $bi (0..$#b) {
    print "(declare-const x$bi Int)\n";
    print "(assert (>= x$bi 0))\n";
}

for my $ci (0..$#c) {
    my @bi = map "x$_", grep { any {$_ == $ci} @{$b[$_]} } 0..$#b;
    print "(assert (= (+ @bi) $c[$ci]))\n";
}

my @bi = map "x$_", 0..$#b;
print "(declare-const m Int)\n";
print "(assert (= (+ @bi) m))\n";
print "(minimize m)\n";

print "(check-sat)\n";
print "(get-value (m))\n";
