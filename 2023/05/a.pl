#!/usr/bin/perl
use strict;

my $type = -1;
my @seeds;
my %map;
while (<>) {
    if (/seeds:/) {
        @seeds = /\d+/g;
    } elsif (/map:/) {
        $type++;
    } elsif (my @numbers = /\d+/g) {
        push @{$map{$type}} => [@numbers];
    }
}

print "Seeds: @seeds\n";
print "Types: $type\n";

my $min;
for my $value (@seeds) {
    print "seed: $value\n";

    type: for my $type (0..$type) {
        for my $map (@{$map{$type}}) {
            my ($dst, $src, $range) = @$map;

            if ($value >= $src && $value < $src + $range) {
                $value = $dst + $value - $src;
                print "type: $type, value maps to $value\n";
                next type;
            }

        }
    }

    $min = $value if $value < $min || !$min;
}

print "Min: $min\n";
