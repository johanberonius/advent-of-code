#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height) = (71, 71);
# my ($width, $height) = (7, 7);
my ($sx, $sy) = (0, 0);
my ($ex, $ey) = ($width-1, $height-1);

for my $y (0..$height-1) {
    for my $x (0..$width-1) {
        $g{"$x,$y"} = '.';
    }
}

# my $l = 12;
my $l = 1024;
while (<>) {
    chomp;
    $g{$_} = '#';
    last unless --$l;
}

print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";
print "End position: $ex, $ey\n";

my %s;
my $m;
my $i = 0;
my @q = [$sx, $sy, 0];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $s, $c) = @$q;
    $i++;

    my $k = "$x,$y";
    next if exists $s{$k} && $s{$k} <= $s;
    $s{$k} = $s;

    if ($x == $ex && $y == $ey) {
        if (!defined $m || $s < $m) {
            $m = $s;
        }
        last;
    }

    my ($wx, $ex) = ($x-1, $x+1);
    my ($ny, $sy) = ($y-1, $y+1);
    push @q => [$wx, $y, $s+1] if $g{"$wx,$y"} eq '.';
    push @q => [$ex, $y, $s+1] if $g{"$ex,$y"} eq '.';
    push @q => [$x, $ny, $s+1] if $g{"$x,$ny"} eq '.';
    push @q => [$x, $sy, $s+1] if $g{"$x,$sy"} eq '.';

    draw();
}

print "Iterations: $i\n";
print "Min steps: $m\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $s = $s{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('on_rgb411'), " • ", color('reset');
            } elsif ($x == $ex && $y == $ey) {
                print color('on_rgb131'), " • ", color('reset');
            } elsif ($s) {
                print color('on_rgb114');
                printf "%-3d", $s;
                print color('reset');
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
    # sleep 0.02;
}