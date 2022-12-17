#!/usr/bin/perl
use strict;
use POSIX;

my @n;
while (<>) {
    chomp;
    push @n => [ split /,|\b|(?=\[)|(?=\])/ ];
}

my $max;
for my $f (0..@n-1) {
    for my $l (0..@n-1) {
        my @m = reduce('[', @{$n[$f]}, @{$n[$l]}, ']');

        my $n = eval join '', map { $_ eq '[' ? $_ : "$_,"} @m;
        my $m = magnitude($n);
        $max = $m if $max < $m;
    }
}

print "Maximug magnitude: $max\n";


sub reduce {
    my @n = @_;

    pass: while(1) {
        # Explode
        my $l = 0;
        for my $i (0..@n-1) {
            if ($n[$i] eq '[') {
                $l++;
                if ($l == 5) {
                    my ($a, $b) = @n[$i+1, $i+2];
                    splice @n, $i, 4, (0);

                    for my $j (reverse 0..$i-1) {
                        if ($n[$j] ne '[' && $n[$j] ne ']') {
                            $n[$j] += $a;
                            last;
                        }
                    }

                    for my $j ($i+1..@n-1) {
                        if ($n[$j] ne '[' && $n[$j] ne ']') {
                            $n[$j] += $b;
                            last;
                        }
                    }

                    next pass;
                }
            } elsif ($n[$i] eq ']') {
                $l--;
            }
        }

        # Split
        for my $i (0..@n-1) {
            if ($n[$i] eq '[') {
            } elsif ($n[$i] eq ']') {
            } elsif ($n[$i] >= 10 ) {
                splice @n, $i, 1, ('[', floor($n[$i]/2), ceil($n[$i]/2), ']');
                next pass;
            }
        }

        last;
    }

    return @n;
}

sub magnitude {
    my $n = shift;
    my ($a, $b) = @$n;
    return
        3 * (ref $a ? magnitude($a) : $a) +
        2 * (ref $b ? magnitude($b) : $b);
}
