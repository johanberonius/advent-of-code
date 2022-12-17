#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my $r = 0;
my $pc = 0;
my @p = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@p, "\n";


my $c = 0;
my %c;

my %t = (
    0 => 'empty',
    1 => 'wall',
    2 => 'block',
    3 => 'paddle',
    4 => 'ball',
);

while (1) {
    my $x = run();
    last if $x eq 'HALT';
    my $y = run();
    last if $y eq 'HALT';
    my $b = run();
    last if $b eq 'HALT';

    print "Block type $t{$b} at $x,$y.\n";
    $c{"$x,$y"} = $b;

    $c++;
}

print "Game halted after $c steps.\n";

for my $b (keys %t) {
    my $n = grep $_ == $b, values %c;
    print "$n $t{$b}s on screen.\n";
}

my @x = map [split ',']->[0], keys %c;
my @y = map [split ',']->[1], keys %c;
my $w = max(@x) - min(@x) + 1;
my $h = max(@y) - min(@y) + 1;
print "Width: $w\n";
print "Height: $h\n";
print "Size: ", $w * $h, "\n";

for my $y (min(@y) .. max(@y)) {
    for my $x (min(@x) .. max(@x)) {
        my $b = $c{"$x,$y"};
        print color('on_black'), '  ' if  $t{$b} eq 'wall';
        print color('on_red'), '  ' if  $t{$b} eq 'block';
        print color('on_blue'), '  ' if  $t{$b} eq 'paddle';
        print color('on_green'), '  ' if  $t{$b} eq 'ball';
        print color('reset'), '  ' if $t{$b} eq 'empty';
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
