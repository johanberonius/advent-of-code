#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my $wood = '∆';
my $lumber = '⩩';
my $open = '•';

my %acres;
my $rows;
my ($width, $height);
my $y = 0;
my $x = 0;
while (<>) {
    chomp;
    $x = 0;
    $acres{$x++.",$y"} = $_ for split '';
    $y++;
}

my $width = $x;
my $height = $y;
my $area = $width * $height;

print "Acres size: $width x $height, area: $area\n";
print "\n";

my $time = 0;
my $woods;
my $lumbers;
my $opens;

draw();
while () {
    my %next;

    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $s = $acres{"$x,$y"};
            my %adjacent;
            my @adjacent = (
                ($x-1).','.($y-1), ($x).','.($y-1), ($x+1).','.($y-1),
                ($x-1).','.($y),                    ($x+1).','.($y),
                ($x-1).','.($y+1), ($x).','.($y+1), ($x+1).','.($y+1),
            );
            @adjacent{@adjacent} = @acres{@adjacent};
            $woods = grep $_ eq '|', values %adjacent;
            $lumbers = grep $_ eq '#', values %adjacent;
            $opens = grep $_ eq '.', values %adjacent;

            if ($s eq '.') {
                $s = '|' if $woods >= 3;
            } elsif ($s eq '|') {
                $s = '#' if $lumbers >= 3;
            } elsif ($s eq '#') {
                $s = '.' if !$lumbers || !$woods;
            }

            $next{"$x,$y"} = $s;
        }
    }

    %acres = %next;
    $woods = grep $_ eq '|', values %acres;
    $lumbers = grep $_ eq '#', values %acres;
    $opens = grep $_ eq '.', values %acres;
    $time++;
    draw();
    last if $time >= 10;
}

print "Total resource value: ", $woods * $lumbers, "\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    print "Time: $time, wood: $woods, lumber: $lumbers, open: $opens\n";
    $lines++;
    my $p = ' ';
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $s = $acres{"$x,$y"};
            print color('rgb020', 'on_rgb141'), $p, $wood, $p if $s eq '|';
            print color('rgb210', 'on_rgb221'), $p, $lumber, $p if $s eq '#';
            print color('rgb115', 'on_rgb225'), $p, $open, $p if $s eq '.';
        }
        print color('reset'), "\n";
        $lines++;
    }
    sleep 0.4;
}
