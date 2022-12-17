#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @n = <> =~ /(\d)/g;

print "Signal loaded, length: ", 0+@n, "\n";

print "Input signal: ", join('', @n), "\n";

my $o = 0+join('', @n[0..6]);
print "Message offset: $o\n";

@n = (@n) x 10_000;
print "Signal total length: ", 0+@n, "\n";

splice @n, 0, $o;
print "Signal trucated length: ", 0+@n, "\n";

@n = reverse @n;

for my $p (1..100) {
    my $s = 0;
    @n = map { $s = ($s + $_) % 10 } @n;
    print "After $p phases...\n";
}

@n = reverse @n;

print "Final output: ", join('', @n[0..7]), "\n";
