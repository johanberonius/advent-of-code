#!/usr/bin/perl
use strict;

my %l;
my %n;
while (<>) {
    chomp;
    my ($n1, $n2) = split '-';
    $n{$n1}++;
    $n{$n2}++;
    $l{"$n1-$n2"}++;
    $l{"$n2-$n1"}++;
}

print "Computers: ", 0+keys %n, "\n";
print "Links: ", (keys %l)/2, "\n";

my $c = 0;
my @n = sort keys %n;
for my $i1 (0..$#n-2) {
    my $n1 = $n[$i1];
    for my $i2 ($i1..$#n-1) {
        my $n2 = $n[$i2];
        next unless $l{"$n1-$n2"};
        for my $i3 ($i2..$#n) {
            my $n3 = $n[$i3];
            next unless $l{"$n1-$n3"} && $l{"$n2-$n3"};
            next unless $n1 =~ /^t/ || $n2 =~ /^t/ || $n3 =~ /^t/;
            print "$n1,$n2,$n3\n";
            $c++;
        }
    }
}

print "Count: $c\n";
