#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my %s;
my %v;
my %l;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);
my ($dx, $dy);
my ($px, $py);
my %d = (
    '0,-1' => '↑',
    '1,0' => '→',
    '0,1' => '↓',
    '-1,0' => '←',
);
my $c;

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        if ($g eq '^') {
            ($sx, $sy) = ($x, $y);
            $g = '.'
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;
print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";

for my $y (0..$height-1) {
    for my $x (0..$width-1) {
        next if $x == $sx && $y == $sy;
        next unless $g{"$x,$y"} eq '.';
        $g{"$x,$y"} = '#';

        ($px, $py) = ($sx, $sy);
        ($dx, $dy) = (0, -1);
        %s = ();
        %v = ();

        $c = 0;
        while(1) {
            $s{"$px,$py,$dx,$dy"}++;
            $v{"$px,$py"}++;
            draw();

            my ($nx, $ny) = ($px + $dx, $py + $dy);
            last unless $g{"$nx,$ny"};

            if ($g{"$nx,$ny"} eq '#') {
                ($dx, $dy) = (-$dy, $dx);
                next;
            }

            ($px, $py) = ($nx, $ny);
        } continue {
            if ($s{"$px,$py,$dx,$dy"}) {
                $l{"$x,$y"}++;
                last;
            }

            $c++;
        }

        $g{"$x,$y"} = '.';
    }
}

print "Obstruction positions: ", 0+keys %l, "\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $v = $v{"$x,$y"};
            my $l = $l{"$x,$y"};
            my $d = $d{"$dx,$dy"};

            if ($l) {
                print color('on_rgb311'), " ◯ ", color('reset');
            } elsif ($x == $px && $y == $py) {
                print color('on_rgb113'), " $d ", color('reset');
            } elsif ($v) {
                print color('on_rgb113'), " • ", color('reset');
            } elsif ($g eq '#') {
                print color('on_rgb111'), "   ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "Steps: $c\n";
    $lines++;
    # sleep 0.01;
}
