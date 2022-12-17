#!/usr/bin/perl
use strict;

my @d = (0..10_006);
while (<>) {
    # print;
    if (/new stack/) {
        @d = reverse @d;
    } elsif (/cut\s+(-?\d+)/) {
        my $i = 0+$1;
        if ($i > 0) {
            push @d => splice @d, 0, $i;
        } elsif ($i < 0) {
            unshift @d => splice @d, $i;
        } else {
            die "Cut by zero";
        }
    } elsif (/increment\s+(\d+)/) {
        my $i = 0+$1;
        my $j = 0;
        my @n;
        for my $k (0..$#d) {
            $n[$j % @d] = $d[$k];
            $j += $i;
        }
        @d = @n;
    } else {
        die "Unrecognized rule: $_";
    }
}

my ($r) = grep $d[$_] == 2019, 0..$#d;

print "Result: $r\n";


# use Data::Dumper;
# print Dumper(\@d);
# print "Length: ", 0+@d, "\n";