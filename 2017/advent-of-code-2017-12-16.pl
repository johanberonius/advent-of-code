#!/usr/bin/perl
use strict;

my @d = 'a'..'p';
# my @d = 'a'..'e';
my $c = 0;

$/ = ',';
while (<>) {
    chomp;
    my ($i, $a, $b) = /([a-z])([a-z0-9]+)\/?([a-z0-9]*)/;
    $c++;

    if ($i eq 's') {
        unshift @d => splice @d, -$a;
    } elsif ($i eq 'x' or $i eq 'p') {
        my %p = map {$d[$_] => $_} 0..$#d;
        ($a, $b) = @p{$a, $b} if $i eq 'p';
        @d[$a,$b] = @d[$b,$a];
    }
}

my @t = map ord($_)-97, @d;

print "Number of intructions: $c\n";
print "Transformation: @t\n";
print "Order after first iteration: ", @d, "\n";
