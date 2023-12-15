#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $e (split '') {
        $g{"$x,$y"} = $e;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "\nGrid width: $width, height: $height\n";
my $r = grep $_ eq 'O', values %g;
print "Rocks: $r\n";

draw();
sleep 1.5;

for (1..3) {
    my $m;
    do {
        $m = 0;
        for my $y (0..$height-2) {
            for my $x (0..$width-1) {
                my $s = $y + 1;
                my $g = $g{"$x,$y"};
                my $o = $g{"$x,$s"};

                if ($g eq '.' && $o eq 'O') {
                    $g{"$x,$s"} = $g;
                    $g{"$x,$y"} = $o;
                    $m++;
                }
            }
        }
        draw();
    } while ($m);
    sleep 0.25;

    do {
        $m = 0;
        for my $x (0..$width-2) {
            for my $y (0..$height-1) {
                my $e = $x + 1;
                my $g = $g{"$x,$y"};
                my $o = $g{"$e,$y"};

                if ($g eq '.' && $o eq 'O') {
                    $g{"$e,$y"} = $g;
                    $g{"$x,$y"} = $o;
                    $m++;
                }
            }
        }
        draw();
    } while ($m);
    sleep 0.25;

    do {
        $m = 0;
        for my $y (reverse 1..$height-1) {
            for my $x (0..$width-1) {
                my $n = $y - 1;
                my $g = $g{"$x,$y"};
                my $o = $g{"$x,$n"};

                if ($g eq '.' && $o eq 'O') {
                    $g{"$x,$n"} = $g;
                    $g{"$x,$y"} = $o;
                    $m++;
                }
            }
        }
        draw();
    } while ($m);
    sleep 0.25;

    do {
        $m = 0;
        for my $x (reverse 1..$width-1) {
            for my $y (0..$height-1) {
                my $w = $x - 1;
                my $g = $g{"$x,$y"};
                my $o = $g{"$w,$y"};

                if ($g eq '.' && $o eq 'O') {
                    $g{"$w,$y"} = $g;
                    $g{"$x,$y"} = $o;
                    $m++;
                }
            }
        }
        draw();
    } while ($m);
    sleep 0.25;
}

my $w = 0;
for my $k (grep $g{$_} eq 'O', keys %g) {
    my ($x, $y) = split ',', $k;
    $w += $height - $y;
}

print "\x1B[", 1, "A";
print "Weight: $w\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            if ($g eq '#') {
                print color('on_rgb111'), "   ", color('reset');
            } elsif ($g eq 'O') {
                print color('on_rgb333'), " ● ", color('reset');
            } else {
                print color('rgb222', 'on_rgb333'), " • ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.1;
}

