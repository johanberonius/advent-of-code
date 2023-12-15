#!/usr/bin/perl
use strict;


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


my $c = 0;
my %c = 0;
my $ff = 0;
while (1) {

    unless ($ff) {
        my $ck = join " ", sort grep $g{$_} eq 'O', keys %g;
        if ($c{$ck}) {
            my $cl = $c - $c{$ck};
            print "Seen state from cycle $c{$ck} after $c cycles, loop length $cl\n";
            my $l = int((1_000_000_000 - $c) / $cl);
            my $cr = $l * $cl;
            $c += $cr;
            print "Loops remaining $l\n";
            print "Cycles remaining $cr\n";
            print "Fast forward to cycle $c\n";
            $ff++;
        }
        $c{$ck} = $c;
    }

    last if $c >= 1_000_000_000;

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
    } while ($m);

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
    } while ($m);

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
    } while ($m);

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
    } while ($m);

    $c++;
}

my $w = 0;
for my $k (grep $g{$_} eq 'O', keys %g) {
    my ($x, $y) = split ',', $k;
    $w += $height - $y;
}

print "Cycles: $c\n";
print "Weight: $w\n";
