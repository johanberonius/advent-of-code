#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my %s;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);
my ($dx, $dy);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        if ($g eq '^') {
            ($sx, $sy) = ($x, $y);
            ($dx, $dy) = (0, -1);
            $g = '.'
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;
my ($px, $py) = ($sx, $sy);
$s{"$px,$py"}++;
my %d = (
    '0,-1' => '↑',
    '1,0' => '→',
    '0,1' => '↓',
    '-1,0' => '←',
);

print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";
draw();

my $c = 0;
while(1) {
    my ($nx, $ny) = ($px + $dx, $py + $dy);

    last unless $g{"$nx,$ny"};

    if ($g{"$nx,$ny"} eq '#') {
        ($dx, $dy) = (-$dy, $dx);
        ($nx, $ny) = ($px + $dx, $py + $dy);
    }

    ($px, $py) = ($nx, $ny);
    $s{"$px,$py"}++;
    $c++;
    draw();
}

print "Positions visited: ", 0+keys %s, "\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $s = $s{"$x,$y"};
            my $d = $d{"$dx,$dy"};

            if ($x == $px && $y == $py) {
                print color('on_rgb113'), " $d ", color('reset');
            } elsif ($s) {
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
    sleep 0.125;
}
