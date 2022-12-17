#!/usr/bin/perl
use strict;

my @p = map 0+$_, split ',', <>;
my $pc = 0;

$p[1] = 12;
$p[2] = 2;
print "Program loaded, length: ", 0+@p, "\n";

while (1) {
    die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

    my $i = $p[$pc];

    if ($i == 1) {
        my $a = $p[++$pc];
        my $b = $p[++$pc];
        my $c = $p[++$pc];
        $p[$c] = $p[$a] + $p[$b];
    } elsif ($i == 2) {
        my $a = $p[++$pc];
        my $b = $p[++$pc];
        my $c = $p[++$pc];
        $p[$c] = $p[$a] * $p[$b];
    } elsif ($i == 99) {
        last;
    } else {
        die "Unknown inctruction: $i";
    }

    $pc++;
}

print "Program halted: $p[0]\n";
