#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %scan;
my $rows;
my ($xmin, $xmax, $ymin, $ymax);
while (<>) {
    my ($axis, $main, $from, $to) = /([xy])=(\d+),\s*[xy]=(\d+)(?:\.\.(\d+))?/;

    if ($axis eq 'x') {
        $rows++;
        my $x = $main;
        $xmin = $x if !$xmin || $xmin > $x;
        $xmax = $x if !$xmax || $xmax < $x;
        for my $y ($from..$to) {
            $scan{"$x,$y"} = '#';
            $ymin = $y if !$ymin || $ymin > $y;
            $ymax = $y if !$ymax || $ymax < $y;
        }
    } elsif ($axis eq 'y') {
        $rows++;
        my $y = $main;
        $ymin = $y if !$ymin || $ymin > $y;
        $ymax = $y if !$ymax || $ymax < $y;
        for my $x ($from..$to) {
            $scan{"$x,$y"} = '#';
            $xmin = $x if !$xmin || $xmin > $x;
            $xmax = $x if !$xmax || $xmax < $x;
       }
    }
}

my $width = $xmax - $xmin + 1;
my $height = $ymax - $ymin + 1;
my $area = $width * $height;

print "Scan $xmin, $ymin => $xmax, $ymax, size: $width x $height, area: $area, rows: $rows\n";
print "\n";


my $water = 0;
my $overflow;
my @pipe = ("500,0");
$scan{$pipe[-1]} = '+';

while (@pipe) {
    my $position = $pipe[-1];
    my ($x, $y) = split ',', $position;

    if ($y == $ymax or $overflow) {
        backtrack();
        next;
    } elsif (!$scan{"$x,". ($y+1)}) {
        $y++;
        $overflow = overflow($x, $y+1);
    } elsif (!$scan{($x-1).",$y"}) {
        $x--;
    } elsif (!$scan{($x+1).",$y"}) {
        $x++;
    } else {
        backtrack();
        next;
    }

    push @pipe => "$x,$y";
    $scan{$pipe[-1]} = '~';
    $water++ if $y >= $ymin;
    # draw();
}

draw();

print "Water: $water\n";

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    print "Water: $water\n";
    $lines++;
    my $p = '';
    for my $y (0..$ymax) {
        for my $x ($xmin-2..$xmax+2) {
            my $s = $scan{"$x,$y"};
            print color('rgb225', 'on_rgb005'), $p, '+', $p if $s eq '+';
            print color('rgb225', 'on_rgb005'), $p, '~', $p if $s eq '~';
            print color('rgb225', 'on_rgb005'), $p, '*', $p if $s eq '*';
            print color('rgb100', 'on_rgb110'), $p, '#', $p if $s eq '#';
            print color('black', 'on_rgb420'), $p, '•', $p unless $s;
        }
        print color('reset'), "\n";
        $lines++;
    }
    sleep 0.1;
}

sub backtrack {
    my ($x, $y);
    do {
        pop @pipe;
        ($x, $y) = split ',', $pipe[-1];
    } while ($scan{($x-1).",$y"} and $scan{($x+1).",$y"});
    $overflow = overflow($x, $y+1);
}

sub overflow {
    my $overflow = 0;
    my ($sx1, $sy) = @_;
    my $sx2 = $sx1;
    if ($scan{"$sx1,$sy"} eq '~') {
        $overflow = 1;

        while ($scan{"$sx1,$sy"}) {
            $sx1--;
            if ($scan{"$sx1,$sy"} eq '#') {
                while ($scan{"$sx2,$sy"}) {
                    $sx2++;
                    if ($scan{"$sx2,$sy"} eq '#') {
                        $overflow = 0;
                        last;
                    }
                }
                last;
            }
        }
    }
    return $overflow;
}
