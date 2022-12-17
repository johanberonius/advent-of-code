#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my $r = 0;
my $pc = 0;
my @p = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@p, "\n";


my $c = 0;
# my %c = ('0,0' => 0); # Part one
my %c = ('0,0' => 1); # Part two
my ($x, $y) = (0, 0);
my $d = 0;
my @d = (
    [0, -1],
    [1, 0],
    [0, 1],
    [-1, 0],
);

while (1) {
    print "Robot at $x,$y.\n";

    my $o = run(0+$c{"$x,$y"});
    last if $o eq 'HALT';
    $c{"$x,$y"} = $o;

    print "Painting ", $o ? 'white' : 'black', "\n";

    my $t = run();
    last if $t eq 'HALT';

    print "Turning ", $t ? 'right' : 'left', "\n";

    $t = $t * 2 - 1; # 0 or 1 to -1 or 1
    $d = ($d + $t) % @d;

    $x += $d[$d][0];
    $y += $d[$d][1];
    $c++;
}

print "Robot halted after $c steps.\n";

my $n = keys %c;
print "$n panels painted at least once.\n";


my @x = map [split ',']->[0], keys %c;
my @y = map [split ',']->[1], keys %c;
my $w = max(@x) - min(@x) + 1;
my $h = max(@y) - min(@y) + 1;
print "Width: $w\n";
print "Height: $h\n";

for $y (min(@y) .. max (@y)) {
    for $x (min(@x) .. max(@x)) {
        print color('white', 'on_black'), ' ' if $c{"$x,$y"};
        print color('reset'), ' ' unless $c{"$x,$y"};
    }
    print color('reset'), "\n";
}


sub run {
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
