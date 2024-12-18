#!/usr/bin/perl
use strict;

my @p;
while (<>) {
    @p = split ',', $1 if /Program: (.+)/;
}

my $A = 0;
my $B = 0;
my $C = 0;

sub c {
    my $o = shift;
    $o <= 3 ? $o :
    $o == 4 ? $A :
    $o == 5 ? $B :
    $o == 6 ? $C : die;
}

for my $n (0..1_000_000) {
    $A = $n;
    $B = 0;
    $C = 0;
    my @out = ();
    my $pc = 0;

    my $c = 0;
    while ($pc >= 0 && $pc < @p) {
        my $i = $p[$pc];
        my $o = $p[$pc+1];
        $c++;

        # adv
        if ($i == 0) {
            $A = int $A / 2 ** c($o);
        }
        # bxl
        elsif ($i == 1) {
            $B ^= $o;
        }
        # bst
        elsif ($i == 2) {
            $B = c($o) % 8;
        }
        # jnz
        elsif ($i == 3) {
            if ($A != 0) {
                $pc = $o;
                next;
            }
        }
        # bxc
        elsif ($i == 4) {
            $B ^= $C;
        }
        # out
        elsif ($i == 5) {
            push @out => c($o) % 8;
        }
        # bdv
        elsif ($i == 6) {
            $C = int $A / 2 ** c($o);
        }
        # cdv
        elsif ($i == 7) {
            $C = int $A / 2 ** c($o);
        }

        $pc += 2;
    }

    print "Iteration: $n, steps: $c\n" unless $n % 10_000;

    if (join(',', @out) eq join(',', @p)) {
        print "Output is equal to program for A: $n\n";
        last;
    }
}
