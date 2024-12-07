#!/usr/bin/perl
use strict;

my %g;
my %s;
my %l;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);
my ($dx, $dy);
my ($px, $py);

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
print "Grid width: $width, height: $height, area: ", $width * $height,"\n";
print "Start position: $sx, $sy\n";
print "Size: ", 0+values %g, "\n";
print "Obstructions: ", 0+grep($_ eq '#', values %g), "\n";
print "Positions to check: ", 0+grep($_ eq '.', values %g)-1, "\n";

my $c = 0;
for my $y (0..$height-1) {
    for my $x (0..$width-1) {
        next if $x == $sx && $y == $sy;
        next unless $g{"$x,$y"} eq '.';
        $g{"$x,$y"} = '#';
        $c++;

        ($px, $py) = ($sx, $sy);
        ($dx, $dy) = (0, -1);
        %s = ();

        while(1) {
            $s{"$px,$py,$dx,$dy"}++;

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
        }

        $g{"$x,$y"} = '.';
    }
}

print "Checked positions: $c\n";
print "Obstruction positions: ", 0+keys %l, "\n";
