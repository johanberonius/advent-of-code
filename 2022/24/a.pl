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

my ($startx, $starty) = (0, -1);
my ($endx, $endy) = ($width-1, $height-1);

print "Grid width: $width, height: $height\n";
print "Start: $startx, $starty\n";
print "Goal: $endx, $endy\n";
print "Blizzards: $bliz\n";



my $c = 0;
my $min;
my @q = [0, $startx, $starty];
while (@q) {
    my $q = pop @q;
    my ($step, $x, $y) = @$q;
    $c++;

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

    my $left  = $x > 0 && !@lb;
    my $up    = $y > 0 &&  !@ub;
    my $wait  = !@wb;
    my $right = $x < $endx && $y >=0 && !@rb;
    my $down  = $y < $endy && !@db;

    push @q => [$step, $x-1, $y  ] if $left;
    push @q => [$step, $x,   $y-1] if $up;
    push @q => [$step, $x,   $y  ] if $wait;
    push @q => [$step, $x+1, $y  ] if $right;
    push @q => [$step, $x,   $y+1] if $down;

    unless ($c % 1) {
        print "$c, step: $step, x: $x, y: $y, \t", ($left && '< '), ($up && '^ '), ($wait && 'W '), ($right && '> '), ($down && 'v '), "\t min: $min, q:", 0+@q, "\n";
        draw($x, $y, $step, $left, $up, $wait, $right, $down);
    }


}

print "Iterations: $c\n";
print "Minimum steps: $min\n";

sub bliz {
    my ($x, $y, $step) = @_;

    return (
        $bliz{(($x-$step) % $width).",$y"} eq '>' ? '>' : (),
        $bliz{(($x+$step) % $width).",$y"} eq '<' ? '<' : (),
        $bliz{"$x,".(($y-$step) % $height)} eq 'v' ? 'v' : (),
        $bliz{"$x,".(($y+$step) % $height)} eq '^' ? '^' : (),
    );
}

sub draw {
    my ($x, $y, $step, $left, $up, $wait, $right, $down) = @_;
    for my $gy (-1..$height) {
        for my $gx (-1..$width) {
            my @bliz = bliz($gx, $gy, $step);

            if ($left && $gx == $x-1 && $gy == $y) {
                print color(@bliz ? 'on_red' : 'on_green'), 'L', color('reset');
            } elsif ($up && $gx == $x && $gy == $y-1) {
                print color(@bliz ? 'on_red' : 'on_green'), 'U', color('reset');
            } elsif ($wait && $gx == $x && $gy == $y) {
                print color(@bliz ? 'on_red' : 'on_green'), 'W', color('reset');
            } elsif ($right && $gx == $x+1 && $gy == $y) {
                print color(@bliz ? 'on_red' : 'on_green'), 'R', color('reset');
            } elsif ($down && $gx == $x && $gy == $y+1) {
                print color(@bliz ? 'on_red' : 'on_green'), 'D', color('reset');
            } elsif ($grid{"$gx,$gy"} eq '#') {
                print color('on_black'), '⌗', color('reset');
            } elsif (@bliz == 1) {
                print color('on_blue'), $bliz[0], color('reset');
            } elsif (@bliz > 1) {
                print color('on_blue'), 0+@bliz, color('reset');
            } else {
                print '•';
            }
        }
        print "\n";
    }
    print "\n";
}


# 441 too high