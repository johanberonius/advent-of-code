#!/usr/bin/perl
use strict;
use List::Util qw(max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my %g;
my ($x, $y) = (0, 0);
my ($sx, $sy) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $e (split '') {
        $g{"$x,$y"} = $e;
        ($sx, $sy) = ($x, $y) if $e eq 'S';
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";

my %ne = ('S' => 1, '|' => 1, 'L' => 1, 'J' => 1);
my %se = ('S' => 1, '|' => 1, 'F' => 1, '7' => 1);
my %we = ('S' => 1, '-' => 1, 'J' => 1, '7' => 1);
my %ee = ('S' => 1, '-' => 1, 'F' => 1, 'L' => 1);

my %s;
my @q = ["0 ", $sx, $sy];
while (@q) {
    my $q = shift @q;
    my ($s, $x, $y) = @$q;
    next if $s{"$x,$y"};
    my $g = $g{"$x,$y"};
    $s{"$x,$y"} = $s;

    my ($ny, $sy) = ($y-1, $y+1);
    my ($wx, $ex) = ($x-1, $x+1);

    my $ng = $g{"$x,$ny"};
    my $ns = $s{"$x,$ny"};
    my $sg = $g{"$x,$sy"};
    my $ss = $s{"$x,$sy"};
    my $eg = $g{"$ex,$y"};
    my $es = $s{"$ex,$y"};
    my $wg = $g{"$wx,$y"};
    my $ws = $s{"$wx,$y"};

    push @q => [$s+1, $x, $ny] if !$ns && $ne{$g} && $se{$ng};
    push @q => [$s+1, $x, $sy] if !$ss && $se{$g} && $ne{$sg};
    push @q => [$s+1, $wx, $y] if !$ws && $we{$g} && $ee{$wg};
    push @q => [$s+1, $ex, $y] if !$es && $ee{$g} && $we{$eg};

    draw();
}


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $s = $s{"$x,$y"};
            if ($x == $sx && $y == $sy) {
                print color('rgb555', 'on_rgb114'), " $g ", color('reset');
            } elsif ($s) {
                print color('on_rgb333');
                printf "%-2d ", $s;
                print color('reset');
            } elsif ($g eq '-') {
                print color('on_rgb333'), "───", color('reset');
            } elsif ($g eq 'F') {
                print color('on_rgb333'), " ┌─", color('reset');
            } elsif ($g eq '7') {
                print color('on_rgb333'), "─┐ ", color('reset');
            } elsif ($g eq 'J') {
                print color('on_rgb333'), "─┘ ", color('reset');
            } elsif ($g eq 'L') {
                print color('on_rgb333'), " └─", color('reset');
            } elsif ($g eq '|') {
                print color('on_rgb333'), " │ ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    sleep 0.5;
}

my $m = max values %s;
print "Max steps: $m\n";
