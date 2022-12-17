#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %p = map { /(\w+)\)(\w+)/; $2 => $1 } <>;

# Find list of ancestors for YOU
my @ya;
my $p = 'YOU';
unshift @ya => $p while $p = $p{$p};

# Find list of ancestors for SAN
my @sa;
my $p = 'SAN';
unshift @sa => $p while $p = $p{$p};

# Find first common ancestor
my $a;
while ($ya[0] || $sa[0] and $ya[0] eq $sa[0]) {
    $a = shift @ya;
    $a = shift @sa;
}
print "Common ancestor: $a\n";

# Cut tree at common ancestor (remove parent)
$p{$a} = undef;

# Calc depths
my %d;

for my $k (keys %p) {
    my $d = 0;
    my $p = $k;
    $d++ while $p = $p{$p};
    $d{$k} = $d;
}

# Depth of YOU + depth of SAN - 2
print "Minimum number of orbital transfers required: ", $d{YOU} + $d{SAN} - 2, "\n";
