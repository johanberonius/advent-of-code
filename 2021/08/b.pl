#!/usr/bin/perl
use strict;
use List::Util qw(all);

my %p;
my %n;
my $s = 0;
while (<>) {
    my ($p, $d) = split /\s*\|\s*/;
    my @p = map { join '', sort split '' } split /\s+/, $p;
    my @d = map { join '', sort split '' } split /\s+/, $d;

    for my $p (@p) {
        if (length $p == 2) {
            $p{$p} = 1;
            $n{1} = $p;
        } elsif (length $p == 4) {
            $p{$p} = 4;
            $n{4} = $p;
        } elsif (length $p == 3) {
            $p{$p} = 7;
            $n{7} = $p;
        } elsif (length $p == 7) {
            $p{$p} = 8;
            $n{8} = $p;
        }
    }

    for my $p (@p) {
        if (length $p == 5) {
            if (all { $p =~ /$_/ } split '', $n{1}) {
                $p{$p} = 3;
                $n{3} = $p;
            } elsif (3 == grep { $p =~ /$_/ } split '', $n{4}) {
                $p{$p} = 5;
                $n{5} = $p;
            } else {
                $p{$p} = 2;
                $n{2} = $p;
            }
        } elsif (length $p == 6) {
            unless (all { $p =~ /$_/ } split '', $n{1}) {
                $p{$p} = 6;
                $n{6} = $p;
            } elsif (all { $p =~ /$_/ } split '', $n{4}) {
                $p{$p} = 9;
                $n{9} = $p;
            } else {
                $p{$p} = 0;
                $n{0} = $p;
            }
        }
    }

    my $n = join '', map $p{$_}, @d;
    $s += $n;
    print "@p | @d | $n\n";
}

print "Sum: $s\n";
