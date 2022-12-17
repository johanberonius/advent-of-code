#!/usr/bin/perl
use strict;
use List::Util qw(min max sum);
use Term::ANSIColor;

my ($l, $x, $y) = (0, -2, -2);
my %c;
while (<>) {
    chomp;
    $c{$l .','. $x++ .','. $y} = $_ eq '#' for split '';
    $y++;
    $x = -2;
}

my @x = map [split ',']->[1], keys %c;
my @y = map [split ',']->[2], keys %c;
my $lmin = 0;
my $lmax = 0;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
print "x: $xmin - $xmax\n";
print "y: $ymin - $ymax\n";
print "Width: $w\n";
print "Height: $h\n";
print "Size: ", $w * $h, "\n";

print "Initial state:\n";
draw();

my %d;
my %n;
my $c = 0;
while ($c < 200) {
    %n = ();
    unless ($c % 2 ) {
        $lmin--;
        $lmax++;
    }
    for my $l ($lmin .. $lmax) {
        for my $y ($ymin .. $ymax) {
            for my $x ($xmin .. $xmax) {
                next if $x == 0 && $y == 0;
                my ($n, $s) = ($y - 1, $y + 1);
                my ($w, $e) = ($x - 1, $x + 1);
                my @n;

                if ($w < -2) {
                    push @n => $l-1 .',-1,0';
                } elsif ($w == 0 && $y == 0) {
                    push @n => map $l+1 .",2,$_", -2..2;
                } else {
                    push @n => "$l,$w,$y";
                }

                if ($e > 2) {
                    push @n => $l-1 .',1,0';
                } elsif ($e == 0 && $y == 0) {
                    push @n => map $l+1 .",-2,$_", -2..2;
                } else {
                    push @n => "$l,$e,$y";
                }

                if ($n < -2) {
                    push @n => $l-1 .',0,-1';
                } elsif ($x == 0 && $n == 0) {
                    push @n => map $l+1 .",$_,2", -2..2;
                } else {
                    push @n => "$l,$x,$n";
                }

                if ($s > 2) {
                    push @n => $l-1 .',0,1';
                } elsif ($x == 0 && $s == 0) {
                    push @n => map $l+1 .",$_,-2", -2..2;
                } else {
                    push @n => "$l,$x,$s";
                }

                my $c = $c{"$l,$x,$y"};
                my $b = sum @c{@n};

                if ($c and $b != 1) {
                    $n{"$l,$x,$y"} = 0;
                } elsif (!$c and $b == 1 || $b == 2) {
                    $n{"$l,$x,$y"} = 1;
                } else {
                    $n{"$l,$x,$y"} = $c;
                }
            }
        }
    }

    %c = %n;
    $c++;
}

print "After $c minutes.\n";
draw();
print "Bugs present: ", sum(values %c), "\n";


sub draw {
    for my $pl ($lmin .. $lmax) {
        print "Depth $pl:\n";
        for my $py ($ymin .. $ymax) {
            for my $px ($xmin .. $xmax) {
                my $c = $c{"$pl,$px,$py"};
                if ($c) {
                    print color('white', 'on_black'), ' 🐞 ';
                } else {
                    print color('black', 'on_blue'), '  • ';
                }
            }
            print color('reset'), "\n";
        }
    }
}

