#!/usr/bin/perl
use strict;

my %c;
while (<>) {
    /(\w+)-(\w+)/ or die "Unexpected input: $_";
    push @{$c{$1}} => $2;
    push @{$c{$2}} => $1;
}

my @r;
my @q = (['start']);

while (@q) {
    my $q = shift @q;
    if ($q->[-1] eq 'end') {
        push @r => $q;
        next;
    }

    for my $c (@{$c{$q->[-1]}}) {
        push @q => [@$q, $c] unless $c eq lc $c && grep $_ eq $c, @$q;
    }
}

print map { join(',', @$_) . "\n"} @r;
print "Found ", 0+@r, " routes.\n";
