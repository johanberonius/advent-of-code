#!/usr/bin/perl
use strict;
use List::Util qw(min max sum);


my @b = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@b, "\n";




my $smin = 1.232;
my $smax = 1.457;
my $sdif = $smax - $smin;

my $sx = (100 + 100 * $smin) / $sdif;
my $sy = int $sx * $smax - 100;


my $y = $sy;
while (1) {
    my $lx = $y * $sx / $sy;
    for my $x ($lx-8..$lx+8) {
        my $p1 = run($x, $y);
        my $p2 = run($x + 99, $y);
        my $p3 = run($x, $y + 99);
        if ($p1 && $p2 && $p3) {
            print "Matching position: $x,$y => ", $x * 10_000 + $y, "\n";
        }
    }
    last if --$y < $sy - 200;
}


# 990_1343 is too high
# 982_1332 is too high


sub run {
    my $r = 0;
    my $pc = 0;
    my @p = @b;
    my $o;

    while (1) {
        die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

        my $i = $p[$pc] % 100;
        my @m = reverse split '', int($p[$pc] / 100);
        $pc++;

        my $param = sub {
            my $w = shift;
            my $m = shift @m;
            my $a = $p[$pc++];
            $a = $r + $a if $m == 2;
            die "Immediate mode not valid for write parameter" if $w && $m == 1;
            $a = $p[$a] if ($m == 0 || $m == 2) && !$w;
            return $a;
        };

        # ADD, MUL, LESS THAN, EQUALS
        if ($i == 1 || $i == 2 || $i == 7 || $i == 8) {
            my $a = $param->();
            my $b = $param->();
            my $c = $param->('w');

            $p[$c] = $a + $b if $i == 1;
            $p[$c] = $a * $b if $i == 2;
            $p[$c] = 0+($a < $b) if $i == 7;
            $p[$c] = 0+($a == $b) if $i == 8;
        }
        # INPUT
        elsif ($i == 3) {
            my $a = $param->('w');
            my $b = 0+shift;
            # print "Input: $b\n";
            $p[$a] = $b;
        }
        # OUTPUT
        elsif ($i == 4) {
            my $a = $param->();
            # print "Output: $a\n";
            $o = $a;
            last;
        }
        # JUMP if true, JUMP if false
        elsif ($i == 5 || $i == 6) {
            my $a = $param->();
            my $b = $param->();

            if ($i == 5 && $a or $i == 6 && !$a) {
                $pc = $b;
                next;
            }
        }
        # RELATIVE BASE
        elsif ($i == 9) {
            my $a = $param->();
            $r += $a;
        }
        # HALT
        elsif ($i == 99) {
            print "Program halted.\n";
            $o = 'HALT';
            last;
        } else {
            die "Unknown inctruction: $i";
        }
    }

    return $o;
}
