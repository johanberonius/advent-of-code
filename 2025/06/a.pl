#!/usr/bin/perl
use strict;

my @n;
while (<>) {
    s/^\s*|\s*$//;
    my @i = split /\s+/;
    push @{$n[$_]} => $i[$_] for 0..$#i;
}

my $s = 0;
for (@n) {
    my $o = pop @$_;
    my @d = @$_;
    my $r = eval join $o, @d;
    $s += $r;
    print "Digits: @d, operator: $o, result: $r\n";
}

print "Sum: $s\n";
