#!/usr/bin/perl
use strict;

my @p = map 0+$_, split ',', <>;
my $pc = 0;

print "Program loaded, length: ", 0+@p, "\n";

while (1) {
    die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

    my $i = $p[$pc] % 100;
    my @m = reverse split '', int($p[$pc] / 100);

    if ($i == 1) {
        my $a = $p[++$pc];
        my $b = $p[++$pc];
        my $c = $p[++$pc];
        $a = $p[$a] unless $m[0];
        $b = $p[$b] unless $m[1];
        die "Immediate mode not valid for write parameter" if $m[2];
        $p[$c] = $a + $b;
    } elsif ($i == 2) {
        my $a = $p[++$pc];
        my $b = $p[++$pc];
        my $c = $p[++$pc];
        $a = $p[$a] unless $m[0];
        $b = $p[$b] unless $m[1];
        die "Immediate mode not valid for write parameter" if $m[2];
        $p[$c] = $a * $b;
    } elsif ($i == 3) {
        my $a = $p[++$pc];
        die "Immediate mode not valid for write parameter" if $m[0];
        $p[$a] = 0+<>;
    } elsif ($i == 4) {
        my $a = $p[++$pc];
        $a = $p[$a] unless $m[0];
        print $a, "\n";
    } elsif ($i == 99) {
        last;
    } else {
        die "Unknown inctruction: $i";
    }

    $pc++;
}

print "Program halted.\n";
