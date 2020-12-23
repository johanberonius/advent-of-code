#!/usr/bin/perl
use strict;
use Term::ANSIColor;

# my $n = 389125467;
my $n = 123487596;

my @n = map 0+$_, split '', $n;

print "Starting cups: @n\n";

my %v;
my $f;
my $l;
my $p;
# my $m = @n;
my $m = 1_000_000;

print "Total cups: $m\n";

for my $v (@n, @n+1..$m) {
    $l = { v => $v };
    if ($p) {
        $p->{n} = $l;

    } else {
        $f = $l;
    }
    $v{$v} = $l;
    $p = $l;
}

$l->{n} = $f;


my $s = 3;
my $c = $f;
my $i = 0;
my $l = 10_000_000;
print "Iterations: $l\n";
print "\n";
while (++$i <= $l) {
    unless ($i % 100_000) {
        print "\x1B[1A";
        printf color('on_black') . " " x (1 + 50*$i/$l) . color('reset'). " %2.0f%%\n", 100*$i/$l;
    }

    my ($p1, $p2, $p3) = ($c->{n}, $c->{n}{n}, $c->{n}{n}{n});
    $c->{n} = $p3->{n};

    my $d = $v{$c->{v}-1} || $v{$m};
    $d = $v{$d->{v}-1} || $v{$m} while $d == $p1 || $d == $p2 || $d == $p3;

    $n = $d->{n};
    $d->{n} = $p1;
    $p3->{n} = $n;

    $c = $c->{n};
}

print "Labels after 1: $v{1}{n}{v} and $v{1}{n}{n}{v}, product: ", $v{1}{n}{v} * $v{1}{n}{n}{v}, "\n";
