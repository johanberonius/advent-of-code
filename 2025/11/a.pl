#!/usr/bin/perl
use strict;

my %d;
while (<>) {
    chomp;
    my ($d, @o) = split /:?\s+/;
    $d{$d} = \@o;
}

my $p = 0;

my @q = ('you');
while (@q) {
    my $d = shift @q;

    if ($d eq 'out') {
        $p++;
        next;
    }

    die unless $d{$d};

    push @q => @{$d{$d}};
}

print "Paths: $p\n";
