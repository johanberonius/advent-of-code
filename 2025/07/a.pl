#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        if ($g eq 'S') {
            ($sx, $sy) = ($x, $y);
            $g = '.';
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "\n";


my $split = 0;
my @q = [$sx, $sy];
while (@q) {
    my $q = shift @q;
    my ($x, $y) = @$q;
    my ($w, $e) = ($x-1, $x+1);
    my ($n, $s) = ($y-1, $y+1);

    if ($g{"$x,$y"} eq '^') {
        $split++;
        push @q => [$w, $y];
        push @q => [$e, $y];
    } elsif ($g{"$x,$y"} eq '.') {
        $g{"$x,$y"} = '|';
        push @q => [$x, $s];
    }

    draw();
}

print "Split $split times.\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('on_rgb411'), " S ", color('reset');
            } elsif ($g eq '|') {
                print color('on_rgb114'), " ┃ ", color('reset');
            } elsif ($g eq '^') {
                print color('on_rgb111'), "━┻━", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.02;
}
