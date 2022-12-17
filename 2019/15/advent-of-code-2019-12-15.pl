#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my $r = 0;
my $pc = 0;
my @p = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@p, "\n";



my $c = 0;
my ($x, $y) = (0, 0);
my %d = (
    1 => [0, -1],
    2 => [0, 1],
    3 => [-1, 0],
    4 => [1, 0],
);
my %rev = (
    1 => 2,
    2 => 1,
    3 => 4,
    4 => 3,
);
my @q = ([1], [2], [3], [4]);
my %c = ("$x,$y" => 1);

L: while (@q) {
    ($x, $y) = (0, 0);
    my $q = shift @q;

    for my $dir (@$q) {
        my $nx = $x + $d{$dir}[0];
        my $ny = $y + $d{$dir}[1];
        my $o = run($dir);
        last L if $o eq 'HALT';

        # Wall square
        if ($o == 0) {
            # No move, mark as wall
            $c{"$nx,$ny"} = '#';
            draw();

            # Backtrack all but last move
            pop @$q;
            for my $dir (reverse @$q) {
                run($rev{$dir}) == 1 or die "Unsuccessfull backtrack move after hitting a wall";
            }
            ($x, $y) = (0, 0);
        }
        # Unvisited square
        elsif ($o == 1 && !$c{"$nx,$ny"}) {
            $c{"$nx,$ny"} = $c{"$x,$y"} + 1;
            $x = $nx;
            $y = $ny;
            draw();

            # Push moves to unvisited squares
            for my $dir (1..4) {
                my $nx = $x + $d{$dir}[0];
                my $ny = $y + $d{$dir}[1];
                push @q => [@$q, $dir] unless $c{"$nx,$ny"};
            }

            # Backtrack
            for my $dir (reverse @$q) {
                run($rev{$dir}) == 1 or die "Unsuccessfull backtrack move after unvisited square";
            }
            ($x, $y) = (0, 0);
        }
        # Visited square
        elsif ($o == 1 && $c{"$nx,$ny"}) {
            $x = $nx;
            $y = $ny;
        }
        # Oxygen square
        if ($o == 2) {
            $c{"$nx,$ny"} = 'X';
            draw();
            print "Oxygen tank found at $nx,$ny, distance: ", $c{"$x,$y"}, "\n";
            last L;
        }
    }

    $c++;
}

print "Robot halted after $c steps.\n";



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
    print "Robot: $x,$y  \n";
    $lines++;


    for my $py (min(@y, -20) .. max(@y, 20)) {
        for my $px (min(@x, -20) .. max(@x, 20)) {
            my $c = $px == $x && $py == $y ? 'on_blue' : 'on_green';
            my $b = $c{"$px,$py"};
            print color('on_black'), '   ' if  $b eq '#';
            print color('on_red'), ' X ' if  $b eq 'X';
            print color($c), sprintf '%3d', $b if $b > 0;
            print color('reset'), '   ' unless $b;
        }
        print color('reset'), "\n";
        $lines++;
    }

    # sleep 0.1;
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
