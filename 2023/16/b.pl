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

my $s = 0;
my $m = 0;
for my $q (
    map([$_, 0, 0, +1], 0..$width-1),
    map([$width-1, $_, -1, 0], 0..$height-1),
    map([$_, $height-1, 0, -1], 0..$width-1),
    map([0, $_, +1, 0], 0..$height-1),
    ) {
    print "Start position: $q->[0],$q->[1]\n";

    %e = ();
    %s = ();
    $s = 0;
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

        # draw();
    }

    my $e = values %e;
    $m = $e if $e > $m;

    # print "\x1B[", 1, "A";
    print "Energized tiles: $e\n";
}

print "Max energized tiles: $m\n";



my $lines;
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
    print "Steps: $s\n";
    $lines++;
    print "\n";
    $lines++;
    sleep 0.1;
}

