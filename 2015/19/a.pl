#!/usr/bin/perl
use strict;

my @r;
my $t;
while (<>) {
    if (/(\w+) => (\w+)/) {
        push @r => [$1, $2];
    } elsif (/(\w+)/) {
        $t = $1;
    }
}

my %s;
for my $r (@r) {
    $t =~ s/$r->[0]/$s{"$`$r->[1]$'"}++; $&/ge;
}


my $m = 0+keys %s;
print "Molecules: $m\n";
