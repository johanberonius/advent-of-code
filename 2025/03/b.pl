#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $sum = 0;
while (<>) {
    chomp;
    my $r = $_;
    print "$r: ";

    while (length($r) > 12) {
        $r = max map {
            my $n = $r;
            substr $n, $_, 1, '';
            $n;
        } 0..length($r)-1;        
    }
    
    print "$r\n";
    $sum += $r;
}

print "Total output joltage: $sum\n";

# 168311581231915 to low
