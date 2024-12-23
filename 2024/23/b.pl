#!/usr/bin/perl
use strict;
use List::Util qw(all);

my %l;
my %n;
while (<>) {
    chomp;
    my ($n1, $n2) = split '-';
    $n{$n1}++;
    $n{$n2}++;
    $l{"$n1-$n2"}++;
    $l{"$n2-$n1"}++;
    push @{$l{$n1}} => $n2;
    push @{$l{$n2}} => $n1;
}

my @n = sort keys %n;
my %s;
for my $n (@n) {
    print "Group from $n, ";
    my @g = ($n);

    my %c;
    while (1) {
        my $a = 0;
        for my $l (map @{$l{$_}}, @g) {
            next if $c{$l}++;
            next unless all { $l{"$l-$_"} } @g;
            push @g => $l;
            $a++;
        }
        last unless $a;
    }

    my $g = join ',', sort @g;
    print "size: ", 0+@g, ", $g\n";
    $s{$g} = 0+@g;
}

my ($g) = sort { $s{$b} <=> $s{$a} } keys %s;
print "Largest group: $s{$g}, $g\n";
