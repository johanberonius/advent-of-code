#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @p;
my @l;
while (<>) {
    chomp;

    if (/^\d:/) {
        my $b = 0;
        $b += grep $_ eq '#', split '', <> for 0..2;
        push @p => $b;

    } elsif (/(\d+)x(\d+): (.+)/) {
        push @l => [$1, $2, split ' ', $3];
    }
}

for my $pi (0..$#p) {
    print "$pi: $p[$pi] blocks\n";
}

my $c = 0;
for (@l) {
    my ($w, $h, @q) = @$_;
    my $a = $w * $h;
    my $r = sum map $q[$_] * $p[$_], 0..$#q;
    $c++ if $r <= $a;
    print "w: $w, h: $h, q: @q, a: $a, r: $r\n";
}

print "Regions: $c\n";
