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
    my $p = $q->[-1];
    if ($p eq 'end') {
        push @r => $q;
        next;
    }

    my %d;
    $d{$_}++ for grep $_ eq lc $_, @$q;
    next if grep $_ > 2, values %d;
    next if 2 == grep $_ == 2, values %d;

    for my $c (@{$c{$p}}) {
        next if $c eq 'start';
        push @q => [@$q, $c];
    }
}

print map { join(',', @$_) . "\n"} @r;
print "Found ", 0+@r, " routes.\n";
