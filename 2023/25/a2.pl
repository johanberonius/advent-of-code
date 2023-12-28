#!/usr/bin/perl
use strict;

my %m;
my %n;
while (<>) {
    my ($s, @d) = /(\w+)/g or die;

    for my $d (@d) {
        push @{$m{$s}} => $d;
        push @{$m{$d}} => $s;
    }
}

while (%m) {
    last if 3 == map { grep $n{$_}, @$_ } values %m;
    my ($m) = sort { (grep $n{$_}, @{$m{$b}}) <=> (grep $n{$_}, @{$m{$a}}) } keys %m;
    $n{$m} = $m{$m};
    delete $m{$m};
}

my $m = keys %m;
my $n = keys %n;

print "Cluster sizes: $m and $n\n";
print "Product: ", $m * $n, "\n";
