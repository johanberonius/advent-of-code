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

my %n;
my $i = 1;
my @q = [$sx, $sy, [[$sx, $sy, 'S']]];
while (@q) {
    $i++;
    my $q = shift @q;
    my ($x, $y, $p) = @$q;
    my ($w, $e) = ($x-1, $x+1);
    my ($n, $s) = ($y-1, $y+1);

    if ($g{"$x,$y"} eq '^') {
        if ($n{"$x,$y,L"} && $n{"$x,$y,R"}) {

            my $ni = $n{"$x,$y,L"} + $n{"$x,$y,R"};
            for (@$p) {
                my ($nx, $ny, $nd) = @$_;
                $n{"$nx,$ny,$nd"} += $ni;
                last unless $n{"$nx,$ny,L"} && $n{"$nx,$ny,R"};
                $ni = $n{"$nx,$ny,L"} + $n{"$nx,$ny,R"}
            }

        } else {
            unshift @q => [$e, $y, [[$x, $y, 'R'], @$p]] unless $n{"$x,$y,L"};
            unshift @q => [$w, $y, [[$x, $y, 'L'], @$p]] unless $n{"$x,$y,R"};
        }
    } elsif ($g{"$x,$y"}) {
        $g{"$x,$y"} = '|';
        unshift @q => [$x, $s, $p];
    } else {
        my $ni = 1;
        for (@$p) {
            my ($nx, $ny, $nd) = @$_;
            $n{"$nx,$ny,$nd"} += $ni;
            last unless $n{"$nx,$ny,L"} && $n{"$nx,$ny,R"};
            $ni = $n{"$nx,$ny,L"} + $n{"$nx,$ny,R"}
        }
    }

    draw();
}

print "$i iterations.\n";
print "Branches: ", $n{"$sx,$sy,S"}, "\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $l = $n{"$x,$y,L"};
            my $r = $n{"$x,$y,R"};
            my ($w, $e) = ($x-1, $x+1);

            if ($x == $sx && $y == $sy) {
                print color('on_rgb411'), "  S  ", color('reset');
            } elsif ($g eq '|' && $g{"$w,$y"} eq '^' && $g{"$e,$y"} eq '^') {
                print color('on_rgb114'), "━━┳━━", color('reset');
            } elsif ($g eq '|' && $g{"$w,$y"} eq '^') {
                print color('on_rgb114'), "━━┓  ", color('reset');
            } elsif ($g eq '|' && $g{"$e,$y"} eq '^') {
                print color('on_rgb114'), "  ┏━━", color('reset');
            } elsif ($g eq '|') {
                print color('on_rgb114'), "  ┃  ", color('reset');
            } elsif ($g eq '^' && ($l || $r)) {
                print color('on_rgb111'), sprintf('%2d %2d', $l, $r), color('reset');
            } elsif ($g eq '^') {
                print color('on_rgb111'), "━━┻━━", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), "  •  ", color('reset');
            } else {
                print color('on_rgb333'), "  $g  ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.2;
}
