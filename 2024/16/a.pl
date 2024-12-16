#!/usr/bin/perl
use strict;
use List::Util qw(max any);
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);
my ($ex, $ey);
my ($dx, $dy) = (1, 0);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        if ($g eq 'S') {
            ($sx, $sy) = ($x, $y);
        } elsif ($g eq 'E') {
            ($ex, $ey) = ($x, $y);
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
print "End position: $ex, $ey\n";

my %s;
my %m;
my $m;
my $i = 0;

my @q = [$sx, $sy, $dx, $dy, 0];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $dx, $dy, $s) = @$q;
    $i++;

    my $k = "$x,$y,$dx,$dy";
    next if exists $s{$k} && $s{$k} <= $s;
    $m{"$x,$y"} = $s{$k} = $s;

    if ($x == $ex && $y == $ey) {
        if (!defined $m || $s < $m) {
            $m = $s;
            print "Found new min steps: $m\n";
        }
        next;
    }

    my ($nx, $ny) = ($x+$dx, $y+$dy);
    unshift @q => [$nx, $ny, $dx, $dy, $s+1] if $g{"$nx,$ny"} ne '#';
    push @q => [$x, $y, $dy, -$dx, $s+1000];
    push @q => [$x, $y, -$dy, $dx, $s+1000];

    print "Iterations: $i, queue: ", 0+@q, "\n" unless $i % 10_000;
    draw();
}

print "Iterations: $i\n";
print "Min score: $m\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $m = $m{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('on_rgb114'), " $g ", color('reset');
            } elsif ($x == $ex && $y == $ey) {
                print color('on_rgb131'), " $g ", color('reset');
            } elsif ($m) {
                print color('on_rgb114'), " • ", color('reset');
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
    sleep 0.02;
}
