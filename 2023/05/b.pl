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

my $i = 0;
my $min;
while (@seeds) {
    my $start = shift @seeds;
    my $length = shift @seeds;
    my $end = $start+$length-1;
    print "start: $start, length: $length\n";

    while ($start <= $end) {
        my $value = $start;
        my $min_edge;

        type: for my $type (0..$type) {
            for my $map (@{$map{$type}}) {
                my ($dst, $src, $range) = @$map;
                $i++;

                if ($value >= $src && $value < $src + $range) {
                    my $edge = $src + $range - $value;
                    $min_edge = $edge if $edge < $min_edge || !$min_edge;

                    $value = $dst + $value - $src;
                    next type;
                } elsif ($value >= $src + $range) {
                } elsif ($value < $src) {
                    my $edge = $src - $value;
                    $min_edge = $edge if $edge < $min_edge || !$min_edge;
                } else {
                    die "type: $type, value: $value, dst: $dst, src: $src, range: $range\n";
                }

            }
        }

        $min = $value if $value < $min || !$min;
        $start += $min_edge;
    }
}

print "Min: $min\n";
print "Iterations: $i\n";
