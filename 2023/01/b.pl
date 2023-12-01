#!/usr/bin/perl
use strict;

my %v = (
    one => 1,
    two => 2,
    three => 3,
    four => 4,
    five => 5,
    six => 6,
    seven => 7,
    eight => 8,
    nine => 9
);

my $s = 0;
while (<>) {
    chomp;
    print "$_: ";

    my $re = join '|', keys %v;
    s/$re/$v{$&}.substr $&, -1/eg;
    print "$_: ";
    s/$re/$v{$&}/eg;

    my @n = grep $_, map 0+$_, split '';
    print "$_: $n[0]$n[-1]\n";
    $s += $n[0] * 10 + $n[-1];
}

print "Sum: $s\n";
