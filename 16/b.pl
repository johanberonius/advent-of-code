#!/usr/bin/perl
use strict;
use List::Util qw(any product);

my @y;
my @t;
my @r;
while (<>) {
    if (1../^$/) {
        push @r => [$1, map 0+$_, $2, $3, $4, $5] if /([\w ]+):\s+(\d+)-(\d+)\s+or\s+(\d+)-(\d+)/g;
    } elsif (/your ticket/../^$/) {
        push @y => map 0+$_, split ',' if /\d+/;
    } elsif (/nearby tickets/..1) {
        push @t => [map 0+$_, split ','] if /\d+/;
    }

}

print "Number of rules: ", 0+@r, "\n";
print "Tickets: ", 0+@t, "\n";
print "Your ticket: @y\n";


my %p;
my $c = 0;
my $v = 0;
t: for my $t (@t) {
    $c++;

    my $i = 0;
    for my $n (@$t) {
        next t unless any {
            my ($id, $min1, $max1, $min2, $max2) = @$_;
            $n >= $min1 && $n <= $max1 or $n >= $min2 && $n <= $max2
        } @r;
    }

    for my $n (@$t) {
        for my $r (@r) {
            my ($id, $min1, $max1, $min2, $max2) = @$r;

            if ($n >= $min1 && $n <= $max1 or $n >= $min2 && $n <= $max2) {
                $p{$id}{$i}++;
            }
        }
        $i++;
    }
    $v++;
}

print "$v valid tickets.\n";

my @d;
while (%p) {
    for my $p (keys %p) {
        my @i = grep $p{$p}{$_} == $v, keys %{$p{$p}};
        next unless @i == 1;
        print "Rule '$p' is field $i[0], my ticket value: $y[$i[0]]\n";

        push @d => $y[$i[0]] if $p =~ /departure/;

        delete $p{$p};
        for my $p (keys %p) {
            delete $p{$p}{$i[0]};
        }

    }
}

print "Values of departure fields: @d, product: ", product(@d), "\n";
