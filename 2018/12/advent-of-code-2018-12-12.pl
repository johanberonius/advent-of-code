#!/usr/bin/perl
use strict;
use List::Util qw(min max sum);

my %i;
my $i = 0;
$i{$i++} = $_ for map { split '' } <> =~ /state:\s+([.#]+)/;

print "$i pots\n";

my %r;
while (<>) {
    /([.#]{5})\s+=>\s+([.#])/ or next;
    next unless $2 eq '#';
    $r{$1} = $2;
}

print 0+keys %r, " rules\n";

my $g = 0;
while () {
    my $min = min(keys %i);
    my $max = max(keys %i);
    my @s = @i{$min..$max};
    print "$g: [$min..$max] ", map($_||'.', @s), "\n";

    last if $g >= 20;

    my %s;
    for $i ($min-2..$max+2) {
        for my $r (keys %r) {
            my @s = @i{$i-2..$i+2};
            my $k = join '', map $_||'.', @s;
            if ($k eq $r) {
                $s{$i} = $r{$r};
                last;
            }
        }
    }
    %i = %s;
    $g++;
}

print "$g generations\n";

my $s = sum grep $i{$_} eq '#', keys %i;
print "Sum: $s\n";
