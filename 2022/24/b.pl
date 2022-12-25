#!/usr/bin/perl
use strict;
use Term::ANSIColor;

my %bliz;
my %grid;
my $bliz = 0;
my ($x, $y) = (-1, -1);

while (<>) {
    chomp;
    $x = -1;
    for my $e (split '') {
        if ($e =~ /[>v<^]/) {
            $bliz{"$x,$y"} = $e;
            $bliz++;
            $e = '.';
        }
        $grid{"$x,$y"} = $e;
        $x++;
    }
    $y++;
}

my ($width, $height) = ($x-1, $y-1);

print "Grid width: $width, height: $height\n";
print "Blizzards: $bliz\n";

path(path(path(0,  0, -1 => $width-1, $height-1), $width-1, $height => 0, 0), 0, -1 => $width-1, $height-1);

sub path {
    my ($startstep, ($startx, $starty), ($endx, $endy)) = @_;
    my $min;
    my %seen;
    my @q = [$startstep, $startx, $starty];
    while (@q) {
        my $q = shift @q;
        my ($step, $x, $y) = @$q;

        next if $seen{"$x,$y,$step"}++;

        next if $min && $step + $endx - $x + $endy - $y >= $min-1;

        if ($x == $endx && $y == $endy) {
            $min = $step+1 if !$min || $step+1 < $min;
            next;
        };

        $step++;
        my @lb = bliz($x-1, $y, $step);
        my @ub = bliz($x, $y-1, $step);
        my @wb = bliz($x, $y, $step);
        my @rb = bliz($x+1, $y, $step);
        my @db = bliz($x, $y+1, $step);

        my $left  = $x > 0 && $y < $height && !@lb;
        my $up    = $y > 0 && !@ub;
        my $wait  = !@wb;
        my $right = $x < $width-1 && $y >=0 && !@rb;
        my $down  = $y < $height-1 && !@db;

        push @q => [$step, $x-1, $y  ] if $left;
        push @q => [$step, $x,   $y-1] if $up;
        push @q => [$step, $x,   $y  ] if $wait;
        push @q => [$step, $x+1, $y  ] if $right;
        push @q => [$step, $x,   $y+1] if $down;
    }

    print "Minimum steps: $min\n";
    return $min;
}

sub bliz {
    my ($x, $y, $step) = @_;

    return (
        $bliz{(($x-$step) % $width).",$y"} eq '>' ? '>' : (),
        $bliz{(($x+$step) % $width).",$y"} eq '<' ? '<' : (),
        $bliz{"$x,".(($y-$step) % $height)} eq 'v' ? 'v' : (),
        $bliz{"$x,".(($y+$step) % $height)} eq '^' ? '^' : (),
    );
}
