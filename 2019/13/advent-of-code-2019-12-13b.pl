#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my $r = 0;
my $pc = 0;
my @p = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@p, "\n";

$p[0] = 2; # Free play

my $s = 0;
my $c = 0;
my %c;
my %t = (
    0 => 'empty',
    1 => 'wall',
    2 => 'block',
    3 => 'paddle',
    4 => 'ball',
);
my ($px, $py);
my ($bx, $by);
my $j = 0;

while (1) {
    my $x = run($j);
    last if $x eq 'HALT';
    my $y = run($j);
    last if $y eq 'HALT';
    my $b = run($j);
    last if $b eq 'HALT';

    if ($x == -1 && $y == 0) {
        $s = $b;
        # print "Current score: $s\n";
    } else {
        # print "Block type $t{$b} at $x,$y.\n";
        $c{"$x,$y"} = $b;
        ($px, $py) = ($x, $y) if $t{$b} eq 'paddle';
        ($bx, $by) = ($x, $y) if $t{$b} eq 'ball';
        $j = $bx <=> $px;
    }

    draw();
    $c++;
}

print "Game halted after $c steps.\n";
print "Final score: $s\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    my @x = map [split ',']->[0], keys %c;
    my @y = map [split ',']->[1], keys %c;
    my $w = max(@x) - min(@x) + 1;
    my $h = max(@y) - min(@y) + 1;
    print "Width: $w\n";
    $lines++;
    print "Height: $h\n";
    $lines++;
    print "Size: ", $w * $h, "\n";
    $lines++;
    print "Current score: $s   \n";
    $lines++;
    print "Paddle: $px,$py  \n";
    $lines++;
    print "Ball: $bx,$by  \n";
    $lines++;

    for my $b (sort { $t{$a} cmp $t{$b} } keys %t) {
        my $n = grep $_ == $b, values %c;
        print "$n $t{$b}s on screen.\n";
        $lines++;
    }

    return unless $h >= 20;

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
        $lines++;
    }

    # sleep 0.01;
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
