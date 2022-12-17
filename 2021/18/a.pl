#!/usr/bin/perl
use strict;
use POSIX;

my @n;
while (<>) {
    chomp;
    my @m = split /,|\b|(?=\[)|(?=\])/;

    unless (@n) {
        @n = @m;
        print "@n\n";
        next;
    }

    print "Add @m\n";
    @n = ('[', @n, @m, ']');
    print "@n\n";
    @n = reduce(@n);
    print "@n\n";
}


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
                    print "Explode [$a,$b]\n";
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

                    print "@n\n";
                    next pass;
                }
            } elsif ($n[$i] eq ']') {
                $l--;
            }
        }

        # Split
        my $l = 0;
        for my $i (0..@n-1) {
            if ($n[$i] eq '[') {
                $l++;
            } elsif ($n[$i] eq ']') {
                $l--;
            } elsif ($n[$i] >= 10 ) {
                print "Split $n[$i]\n";
                splice @n, $i, 1, ('[', floor($n[$i]/2), ceil($n[$i]/2), ']');
                print "@n\n";
                next pass;
            }
        }

        last;
    }

    return @n;
}



my $n = eval join '', map { $_ eq '[' ? $_ : "$_,"} @n;
print "Magnitude: ", magnitude($n), "\n";

sub magnitude {
    my $n = shift;
    my ($a, $b) = @$n;
    return
        3 * (ref $a ? magnitude($a) : $a) +
        2 * (ref $b ? magnitude($b) : $b);
}
