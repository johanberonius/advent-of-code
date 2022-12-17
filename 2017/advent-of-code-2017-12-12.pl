#!/usr/bin/perl
use strict;

my %c;
while (<>) {
    chomp;
    my ($p, $l) = split /\s*<->\s*/;
    $c{$p} = [map 0+$_, split /\s*,\s*/, $l];
}

print "Ids in list: ", 0+keys %c, "\n";

my $g = 0;
while (%c) {
    my $r = (sort {$a <=> $b} keys %c)[0];
    my %v;
    my @l = ($r);
    while (@l) {
        my $i = shift @l;
        push @l => grep !$v{$_}, @{$c{$i}} unless $v{$i}++;
    }

    print "Number in group connected to $r: ", 0+keys %v,"\n";
    delete @c{keys %v};
    $g++;
}

print "Number of groups: $g\n";
