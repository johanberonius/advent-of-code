#!/usr/bin/perl
use strict;
use Time::HiRes qw(time);

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
my $t1 = time;

my %adjacent;
for my $y (0..$height-1) {
    for my $x (0..$width-1) {
        $adjacent{"$x,$y"} = [
            ($x-1).','.($y-1), ($x).','.($y-1), ($x+1).','.($y-1),
            ($x-1).','.($y),                    ($x+1).','.($y),
            ($x-1).','.($y+1), ($x).','.($y+1), ($x+1).','.($y+1),
        ];
    }
}

while () {
    my %next;

    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $pos = "$x,$y";

            $woods = 0;
            $lumbers = 0;
            $opens = 0;

            for my $p (@{$adjacent{$pos}}) {
                my $s = $acres{$p};
                $woods++ if $s eq '|';
                $lumbers++ if $s eq '#';
                $opens++ if $s eq '.';
            }

            my $s = $acres{$pos};

            if ($s eq '.') {
                $s = '|' if $woods >= 3;
            } elsif ($s eq '|') {
                $s = '#' if $lumbers >= 3;
            } elsif ($s eq '#') {
                $s = '.' if !$lumbers || !$woods;
            }

            $next{$pos} = $s;
        }
    }

    %acres = %next;
    $woods = grep $_ eq '|', values %acres;
    $lumbers = grep $_ eq '#', values %acres;
    $opens = grep $_ eq '.', values %acres;
    $time++;

    unless ($time % 1000) {
        my $s = 100 / (time - $t1);
        my $v = $woods * $lumbers;
        print "Time: $time \t wood: $woods \t lumber: $lumbers \t open: $opens\n";
        # print "value: $v, v/t: ", $v/$time, "\n";
        # print "$s/s. eta. ", 1_000_000_000 / $s / 3600, "h.\n";
        $t1 = time;
    }

    last if $time >= 1_000_000_000;
}

print "Time: $time, wood: $woods, lumber: $lumbers, open: $opens\n";
print "Total resource value: ", $woods * $lumbers, "\n";

