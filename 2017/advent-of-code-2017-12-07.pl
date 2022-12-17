#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my %n;
my %p;
my %c;
my %w;
my %t;

while (<>) {
    chomp;
    my ($nw, $cl) = split /\s*->\s*/;
    my ($n, $w) = /(\w+).*?(\d+)/;
    $n{$n}++;
    $w{$n} = 0+$w;
    for my $c (split /,\s*/, $cl) {
        $p{$c} = $n;
        push @{$c{$n}} => $c;
    }
}

my ($r) = grep !$p{$_}, keys %n;
print "Root node: $r\n\n";

for my $n (keys %n) {
    my $p = $n;
    do {
        $t{$p} += $w{$n};
    } while ($p = $p{$p});
}

for my $n (keys %n) {
    my @c = @{$c{$n} || []};
    my $min = min @t{@c};
    my $max = max @t{@c};
    my $d = $max - $min;
    print <<END if $d;
Parent: $n
Children: @c
Weights: @w{@c}
Total weights: @t{@c}
Weights diff: $d

END
}
