#!/usr/bin/perl
use strict;
use List::Util qw(min max sum);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my @b = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@b, "\n";



my $c = 0;
my ($x, $y) = (0, 0);
my %c;
my %smin;
my %smax;
my $xmin = 0;
my $xmax = 0;

for my $py (10000..12999) {
    $y = $py;
    my $lp;
    for my $px ($xmin && $xmax ? ($xmin-1..$xmin+2, $xmax-1..$xmax+2) : (0..$py)) {
        $x = $px;
        $c++;
        my $p = run($x, $y);

        if ($y >= 200 && $x > 1) {
            if ($p && !$lp) {
                $smax{$y} = $y / $x;
                $xmin = $x;
            } elsif (!$p && $lp) {
                $smin{$y} = $y / ($x - 1);
                $xmax = $x - 1;
            }
        }

        $lp = $p;
        $c{"$x,$y"} = $p ? '#' : '.';
    }
    # draw();
}

print "Drone halted after $c steps.\n";

my $n = grep $_ eq '#', values %c;
print "Points are affected by the tractor beam: $n\n";

my $amin = sum(values %smin) / values %smin;
print "Average minimum slope: $amin\n";
# Average minimum slope: 1.232

my $amax = sum(values %smax) / values %smax;
print "Average maximum slope: $amax\n";
# Average maximum slope: 1.457

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
    print "Drone: $x,$y  \n";
    $lines++;


    for my $py (min(@y) .. max(@y)) {
        for my $px (min(@x) .. max(@x)) {
            my $c = $c{"$px,$py"};
            if  ($c eq '#') {
                print color('on_black'), '   ';
            } elsif ($c eq '.') {
                print color('on_blue'), '   ';
            } else {
                print color('reset'), '   ';
            }
        }
        print color('reset');
        printf "%.3f - ", $smax{$py};
        printf "%.3f", $smin{$py};
        print "\n";
        $lines++;
    }

    # sleep 0.1;
}

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
