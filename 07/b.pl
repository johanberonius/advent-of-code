#!/usr/bin/perl
use strict;

my %c;
my $i = 0;
while (<>) {
    my ($c, $o) = split /\s+bags\s+contain\s+/;

    for (split /,\s+/, $o) {
        push @{$c{$c}} => [$1, $2] if /(\d+)\s+(\w+\s+\w+)/;
    }
    $i++;
}

print "Number of bag colors: $i\n";

my $s = 'shiny gold';
my %p;
my $n = bags_in($s);
sub bags_in {
    my $c = shift;
    unless ($p{$c}) {
        for my $p (@{$c{$c}}) {
            my ($i, $j) = @$p;
            $p{$c} += $i + $i * bags_in($j);
        }
    }
    return $p{$c};
}

print "$s contains $n bags.\n";
