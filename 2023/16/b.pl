#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my %e;
my %s;
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

my ($sx, $sy) = (0, 0);
my $lines = 0;
draw();
sleep 1;

my $s = 0;
my $m = 0;
for my $q (
    map([$_, 0, 0, +1], 0..$width-1),
    map([$width-1, $_, -1, 0], 0..$height-1),
    reverse(map([$_, $height-1, 0, -1], 0..$width-1)),
    reverse(map([0, $_, +1, 0], 0..$height-1)),
    ) {
    %e = ();
    %s = ();
    $s = 0;
    ($sx, $sy) = @$q;
    my @q = $q;
    while (@q) {
        my ($x, $y, $dx, $dy) = @{shift @q};
        next unless $x >= 0 && $x < $width && $y >= 0 && $y < $height;
        next if $s{"$x,$y $dx,$dy"}++;
        $s++;
        $e{"$x,$y"}++;
        my $g = $g{"$x,$y"};

        if ($g eq '-' && $dy) {
            push @q => [$x-1, $y, -1, 0];
            push @q => [$x+1, $y, +1, 0];
        } elsif ($g eq '|' && $dx) {
            push @q => [$x, $y-1, 0, -1];
            push @q => [$x, $y+1, 0, +1];

        } elsif ($g eq '/' && $dx == 1) {
            push @q => [$x, $y-1, 0, -1];
        } elsif ($g eq '/' && $dx == -1) {
            push @q => [$x, $y+1, 0, +1];
        } elsif ($g eq '/' && $dy == 1) {
            push @q => [$x-1, $y, -1, 0];
        } elsif ($g eq '/' && $dy == -1) {
            push @q => [$x+1, $y, +1, 0];

        } elsif ($g eq '\\' && $dx == 1) {
            push @q => [$x, $y+1, 0, +1];
        } elsif ($g eq '\\' && $dx == -1) {
            push @q => [$x, $y-1, 0, -1];
        } elsif ($g eq '\\' && $dy == 1) {
            push @q => [$x+1, $y, +1, 0];
        } elsif ($g eq '\\' && $dy == -1) {
            push @q => [$x-1, $y, -1, 0];
        } else {
            $x += $dx;
            $y += $dy;
            push @q => [$x, $y, $dx, $dy];
        }

        draw();
    }

    my $e = values %e;
    $m = $e if $e > $m;

    print "\x1B[", 2, "A";
    print "Energized tiles: $e  \n";
    print "\n";
    sleep 0.25;
}

print "\x1B[", 1, "A";
print "Max energized tiles: $m  \n";



sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $e = $e{"$x,$y"};
            my $c = $e ? 'on_rgb511' : 'on_rgb333';
            if ($e > 1) {
                print color($c), sprintf("%2d " , $e), color('reset');
            } elsif ($g eq '/') {
                print color($c), " ╱ ", color('reset');
            } elsif ($g eq '\\') {
                print color($c), " ╲ ", color('reset');
            } elsif ($g eq '-') {
                print color($c), "───", color('reset');
            } elsif ($g eq '|') {
                print color($c), " │ ", color('reset');
            } elsif ($g eq '.') {
                print color($c), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "Start position: $sx,$sy\n";
    $lines++;
    print "\n" x 2;
    $lines += 2;

    sleep 0.01;
}

