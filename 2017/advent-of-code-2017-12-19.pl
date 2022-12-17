#!/usr/bin/perl
use strict;

my @g;
my ($x, $y) = (0, 0);
my ($dx, $dy) = (0, 1);
my @l;
my $c = 0;
while (<>) {
    chomp;
    push @g => [map { s/\s+//; $_ } split ''];
}

($x) = grep $g[$y][$_], 0..$#{$g[$y]};

while ($x >= 0 and $y >= 0) {
    my $g = $g[$y][$x];
    last unless $g;
    push @l => $g if $g =~ /[A-Z]/;

    if ($g eq '+') {
        ($dx, $dy) = ($dy, $dx);
        ($dx, $dy) = (-$dx, -$dy) unless $g[$y + $dy][$x + $dx];
    }

    $x += $dx;
    $y += $dy;
    $c++;
}

print "Found letters: ", @l, " after $c steps.\n";
