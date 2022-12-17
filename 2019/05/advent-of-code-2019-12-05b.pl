#!/usr/bin/perl
use strict;

my @p = map 0+$_, split ',', <>;
my $pc = 0;

print "Program loaded, length: ", 0+@p, "\n";

while (1) {
    die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

    my $i = $p[$pc] % 100;
    my @m = reverse split '', int($p[$pc] / 100);

    # ADD, MUL, LESS THAN, EQUALS
    if ($i == 1 || $i == 2 || $i == 7 || $i == 8) {
        my $a = $p[++$pc];
        my $b = $p[++$pc];
        my $c = $p[++$pc];
        $a = $p[$a] unless $m[0];
        $b = $p[$b] unless $m[1];
        die "Immediate mode not valid for write parameter" if $m[2];
        $p[$c] = $a + $b if $i == 1;
        $p[$c] = $a * $b if $i == 2;
        $p[$c] = 0+($a < $b) if $i == 7;
        $p[$c] = 0+($a == $b) if $i == 8;
    }
    # INPUT
    elsif ($i == 3) {
        my $a = $p[++$pc];
        die "Immediate mode not valid for write parameter" if $m[0];
        my $b = 0+<>;
        print "Input: $b\n";
        $p[$a] = $b;
    }
    # OUTPUT
    elsif ($i == 4) {
        my $a = $p[++$pc];
        $a = $p[$a] unless $m[0];
        print $a, "\n";
    }
    # JUMP if true, JUMP if false
    elsif ($i == 5 || $i == 6) {
        my $a = $p[++$pc];
        my $b = $p[++$pc];
        $a = $p[$a] unless $m[0];
        $b = $p[$b] unless $m[1];
        if ($i == 5 && $a or $i == 6 && !$a) {
            $pc = $b;
            next;
        }
    }
    # HALT
    elsif ($i == 99) {
        last;
    } else {
        die "Unknown inctruction: $i";
    }

    $pc++;
}

print "Program halted.\n";
