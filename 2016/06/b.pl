#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $f = [];
while (<>) {
    chomp;
    my @l = split '';
    $f->[$_]{$l[$_]}++ for 0..$#l;
}

for (0..$#$f) {
    my ($l) = sort { $f->[$_]{$a} <=> $f->[$_]{$b} } keys %{$f->[$_]};
    print $l;
}

print "\n";