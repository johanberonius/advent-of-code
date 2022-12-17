#!/usr/bin/perl
use strict;
use List::Util qw(min);

(my $p1) = <> =~ /Player 1.+position:\s*(\d+)/ or die;
(my $p2) = <> =~ /Player 2.+position:\s*(\d+)/ or die;

print "Player 1 starting position: $p1\n";
print "Player 2 starting position: $p2\n";

my @q = ([[$p1, $p2], [0, 0], 0, 1]);
my @w;
my $i;

while (@q) {
    my $r = shift @q;
    my ($p, $s, $t, $n) = @$r;

    unless (++$i % 100_000) {
        print "Queue length: ", 0+@q, "\n";
        print "Winners: @w\n";
    }

    my $c = $s->[$t];
    $p->[$t] = ($p->[$t] + 3) % 10 || 10;
    $s->[$t] = $c + $p->[$t];
    if ($s->[$t] >= 21) {
        $w[$t] += $n;
    } else {
        push @q => [ [@$p], [@$s], !$t, $n];
    }


    $p->[$t] = ($p->[$t] + 1) % 10 || 10;
    $s->[$t] = $c + $p->[$t];
    if ($s->[$t] >= 21) {
        $w[$t] += $n*3;
    } else {
        push @q => [ [@$p], [@$s], !$t, $n*3];
    }


    $p->[$t] = ($p->[$t] + 1) % 10 || 10;
    $s->[$t] = $c + $p->[$t];
    if ($s->[$t] >= 21) {
        $w[$t] += $n*6;
    } else {
        push @q => [ [@$p], [@$s], !$t, $n*6];
    }


    $p->[$t] = ($p->[$t] + 1) % 10 || 10;
    $s->[$t] = $c + $p->[$t];
    if ($s->[$t] >= 21) {
        $w[$t] += $n*7;
    } else {
        push @q => [ [@$p], [@$s], !$t, $n*7];
    }


    $p->[$t] = ($p->[$t] + 1) % 10 || 10;
    $s->[$t] = $c + $p->[$t];
    if ($s->[$t] >= 21) {
        $w[$t] += $n*6;
    } else {
        push @q => [ [@$p], [@$s], !$t, $n*6];
    }


    $p->[$t] = ($p->[$t] + 1) % 10 || 10;
    $s->[$t] = $c + $p->[$t];
    if ($s->[$t] >= 21) {
        $w[$t] += $n*3;
    } else {
        push @q => [ [@$p], [@$s], !$t, $n*3];
    }


    $p->[$t] = ($p->[$t] + 1) % 10 || 10;
    $s->[$t] = $c + $p->[$t];
    if ($s->[$t] >= 21) {
        $w[$t] += $n;
    } else {
        push @q => [ [@$p], [@$s], !$t, $n];
    }
}

print "Iterations: $i\n";
print "Winners: @w\n";
