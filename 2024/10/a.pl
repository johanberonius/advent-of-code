#!/usr/bin/perl
use strict;
use Term::ANSIColor;

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);
my @q;

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        push @q => [$x, $y, $g, $x, $y] if $g eq '0';
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;
print "Grid width: $width, height: $height\n";
print "Trail heads: ", 0+@q, "\n";

draw();

my %c;
while (@q) {
    my ($x, $y, $g, $sx, $sy) = @{shift @q};

    if ($g{"$x,$y"} == 9) {
        $c{"$sx,$sy => $x,$y"}++;
        next;
    }

    my ($w, $e) = ($x-1, $x+1);
    my ($n, $s) = ($y-1, $y+1);
    my $h = $g+1;

    push @q => [$w, $y, $h, $sx, $sy] if $g{"$w,$y"} == $h;
    push @q => [$e, $y, $h, $sx, $sy] if $g{"$e,$y"} == $h;
    push @q => [$x, $n, $h, $sx, $sy] if $g{"$x,$n"} == $h;
    push @q => [$x, $s, $h, $sx, $sy] if $g{"$x,$s"} == $h;
}

print "Sum of scores: ", 0+keys %c, "\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};

            if ($g ne '.') {
                print color('on_rgb113'), " $g ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
}
