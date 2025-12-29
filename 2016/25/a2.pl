#!/usr/bin/perl
use strict;

my $ia = 0;
ia: while (1) {
    print "Starting with a: $ia\n";
    my $po;

    my $a = $ia;
    my $b = 0;
    my $c = 0;
    my $d = 0;

    $d = $a;
    $c = 14;
    l2:
    $b = 182;
    l1:
    $d++;
    $b--;
    goto l1 if $b != 0;
    $c--;
    goto l2 if $c != 0;

    l11:
    $a = $d;
    l10:
    $b = $a;
    $a = 0;
    l6:
    $c = 2;
    l5:
    goto l3 if $b != 0;
    goto l4;
    l3:
    $b--;
    $c--;
    goto l5 if $c != 0;
    $a++;
    goto l6;
    l4:
    $b = 2;
    l9:
    goto l7 if $c != 0;
    goto l8;
    l7:
    $b--;
    $c--;
    goto l9;
    l8:

    # out b
    $po = !$b unless defined $po;
    next ia unless $b == !$po;
    $po = $b;

    goto l10 if $a != 0;
    goto l11;

} continue {
    $ia++;
}
