#!/usr/bin/perl
use strict;
use List::Util qw(min max);
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

my @path = <> =~ /(\d+|L|R)/g;
print "Path: @path\n";


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
);
my %path = ("$px,$py" => $dir[$dir][2]);

draw();
sleep 0.5;

for my $step (@path) {
    if ($step > 0) {
        for (1..$step) {
            my $nx = $px + $dir[$dir][0];
            my $ny = $py + $dir[$dir][1];

            if (!$g{"$nx,$ny"}) {
                if ($nx > $px) {
                    $nx = min cols($ny);
                } elsif ($nx < $px) {
                    $nx = max cols($ny);
                } elsif ($ny > $py) {
                    $ny = min rows($nx);
                } elsif ($ny < $py) {
                    $ny = max rows($nx);
                }
            }

            if ($g{"$nx,$ny"} eq '.') {
                ($px, $py) = ($nx, $ny);
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
                print color('on_rgb333'), " $p ", color('reset');
            } elsif ($g eq '#') {
                print color('on_black'), " $g ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb444'), " $g ", color('reset');
            } else {
                print "   ";
            }
        }
        print "\n";
        $lines++;
    }
    sleep 0.25;
}

