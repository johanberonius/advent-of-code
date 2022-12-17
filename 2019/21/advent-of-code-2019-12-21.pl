#!/usr/bin/perl
use strict;
use List::Util qw(min max any);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my $r = 0;
my $pc = 0;
my @p = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@p, "\n";


my @o = run(map ord, split '',
"NOT A J
NOT B T
OR T J
NOT C T
OR T J
AND D J
WALK
");

print "Output value: @o\n";


my ($x, $y) = (0, 0);
my ($rx, $ry) = (0, 0);
my %c;
my %v;
my $l;
sub track {
    my $o = chr shift;
    if ($o eq "\n") {
        $y++;
        $x = 0;

        if ($l eq "\n") {
            $y = 0;

            my ($r) = grep $c{$_} eq '@', keys %c;
            ($rx, $ry) = split ',', $r;
            $v{"$rx,$ry"}++;

            draw();
        }
    } else {
        $c{"$x,$y"} = $o;
        $x++;
    }
    $l = $o;
}


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
    print "Robot: $rx,$ry\n";
    $lines++;

    for my $py (min(@y) .. max(@y)) {
        for my $px (min(@x) .. max(@x)) {
            my $c = $c{"$px,$py"};
            my $v = $v{"$px,$py"};
            if ($c eq '#') {
                print color('white', 'on_black'), sprintf '%3d', $px;
            } elsif ($c eq '@') {
                print color('black', 'on_green'), " $c "
            } elsif ($v) {
                print color('black', 'on_cyan'), ' • ';
            } elsif ($c eq '.') {
                print color('black', 'on_blue'), ' • ';
            }
        }
        print color('reset'), "\n";
        $lines++;
    }

    sleep 0.4;
}


sub run {
    my @o;

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
            if ($a < 256) {
                track($a);
            } else {
                push @o => $a;
            }
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
            last;
        } else {
            die "Unknown inctruction: $i";
        }
    }

    return @o;
}
