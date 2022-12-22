#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Math::Utils qw(gcd);
use Term::ANSIColor;
use Time::HiRes qw(time sleep);


my %g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    last unless $_;
    $x = 0;
    for my $e (split '') {
        $g{"$x,$y"} = $e if $e ne ' ';
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "Grid width: $width, height: $height\n";
my $side = gcd($width, $height);
print "Faces: $side x $side\n";


my @path = <> =~ /(\d+|L|R)/g;
# print "Path: @path\n";


sub cols {
    map $_->[0], grep $_->[1] == $_[0], map [split ','], keys %g;
}

sub rows {
    map $_->[1], grep $_->[0] == $_[0], map [split ','], keys %g;
}

my $py = 0;
my $px = min cols($py);
print "Start position: $px, $py\n";

my $dir = 0;
my @dir = (
    [1, 0, '>'],
    [0, 1, 'v'],
    [-1, 0, '<'],
    [0, -1, '^'],
);
my %turn = (
    R => 1,
    L => -1,
    U => 2,
);
my %path = ("$px,$py" => $dir[$dir][2]);

my %transform = (
    "2,0 => 2,-1" => [0, 1, 'U'],
    "2,0 => 1,0" => [1, 1, 'L'],
    "2,0 => 3,0" => [3, 2, 'U'],

    "0,1 => 0,0" => [2, 0, 'U'],
    "0,1 => -1,0" => [3, 2, 'R'],
    "0,1 => 0,2" => [2, 2, 'U'],

    "1,1 => 1,0" => [2, 0, 'R'],
    "1,1 => 1,2" => [2, 2, 'L'],

    "2,1 => 3,1" => [3, 2, 'R'],

    "2,2 => 1,2" => [1, 1, 'R'],
    "2,2 => 2,3" => [0, 1, 'U'],

    "3,2 => 3,1" => [2, 1, 'L'],
    "3,2 => 4,2" => [2, 0, 'U'],
    "3,2 => 3,3" => [0, 1, 'L'],
);

draw();
sleep 0.25;

my $steps;
for my $step (@path) {
    $steps .= " $step";
    if ($step > 0) {
        for (1..$step) {
            my $nx = $px + $dir[$dir][0];
            my $ny = $py + $dir[$dir][1];
            my $ndir = $dir;

            if (!$g{"$nx,$ny"}) {

                my ($sx, $sy) = (int $px / $side, int $py / $side);
                my ($dx, $dy) = (int $nx / $side, int $ny / $side);
                my ($fx, $fy) = ($nx % $side, $ny % $side);
                my ($tx, $ty, $rotation) = @{$transform{"$sx,$sy => $dx,$dy"}};

                $ndir += $turn{$rotation};
                $ndir %= @dir;

                if ($rotation eq 'L') {
                    ($fx, $fy) = ($fy, $side - 1 - $fx);
                } elsif ($rotation eq 'R') {
                    ($fx, $fy) = ($side - 1 - $fy, $fx);
                } elsif ($rotation eq 'U') {
                    ($fx, $fy) = ($side - 1 - $fx, $side - 1 - $fy);
                }

                ($nx, $ny) = ($tx * $side + $fx, $ty * $side + $fy);

            }

            if ($g{"$nx,$ny"} eq '.') {
                ($px, $py) = ($nx, $ny);
                $dir = $ndir;
                $path{"$px,$py"} = $dir[$dir][2];
                draw();
            }
        }
    } else {
        $dir += $turn{$step};
        $dir %= @dir;
        $path{"$px,$py"} = $dir[$dir][2];
        draw();
    }
}

print "Row: ", $py+1, "\n";
print "Column: ", $px+1, "\n";
print "Facing: ", $dir, "\n";
print "Password: ", ($py+1)*1000 + ($px+1)*4 + $dir, "\n";

my $lines;
my $c = 0;
sub draw {
    # return if $c++ % 100;
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $p = $path{"$x,$y"};
            if ($x == $px && $y == $py) {
                print color('rgb555', 'on_rgb114'), " $p ", color('reset');
            } elsif ($p) {
                my $sx = 1 + int $x / $side;
                my $sy = 1 + int $y / $side;
                print color("on_rgb$sx${sy}3"), " $p ", color('reset');
            } elsif ($g eq '#') {
                my $sx = 0 + int $x / $side;
                my $sy = 0 + int $y / $side;
                print color("on_rgb$sx${sy}2"), " $g ", color('reset');
            } elsif ($g eq '.') {
                my $sx = 2 + int $x / $side;
                my $sy = 2 + int $y / $side;
                print color("on_rgb$sx${sy}4"), " $g ", color('reset');
            } else {
                print "   ";
            }
        }
        print "\n";
        $lines++;
    }
    print "Steps: $steps\n";
    $lines++;
    sleep 0.4;
}

