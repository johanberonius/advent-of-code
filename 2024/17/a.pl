#!/usr/bin/perl
use strict;

my ($A, $B, $C);
my $pc = 0;
my @p;
my @out;
while (<>) {
    $A = $1 if /Register A: (\d+)/;
    $B = $1 if /Register B: (\d+)/;
    $C = $1 if /Register C: (\d+)/;
    @p = split ',', $1 if /Program: (.+)/;
}

sub c {
    my $o = shift;
    $o <= 3 ? $o :
    $o == 4 ? $A :
    $o == 5 ? $B :
    $o == 6 ? $C : die;
}

while ($pc >= 0 && $pc < @p) {
    my $i = $p[$pc];
    my $o = $p[$pc+1];

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

print "Output: ", join(',', @out), "\n";
