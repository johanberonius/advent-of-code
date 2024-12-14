#!/usr/bin/perl
use strict;

my ($width, $height) = (101, 103);
my @r;

while (<>) {
    chomp;
    /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/ or die;
    my ($x, $y) = ($1, $2);
    my ($vx, $vy) = ($3, $4);
    push @r => {x => $x, y => $y, vx => $vx, vy => $vy};

}

my %r;
# my $o = 12;
my $o = 88;
for my $r (@r) {
    $r->{x} = ($r->{x} + $r->{vx} * $o) % $width;
    $r->{y} = ($r->{y} + $r->{vy} * $o) % $height;
    $r{$r->{x} .','. $r->{y}}++;
}
draw();
print "Seconds: ", $o, "\n";

my $c = 0;
# my $s = 101;
my $s = 103;
while(1) {
    %r = ();
    for my $r (@r) {
        $r->{x} = ($r->{x} + $r->{vx} * $s) % $width;
        $r->{y} = ($r->{y} + $r->{vy} * $s) % $height;
        $r{$r->{x} .','. $r->{y}}++;
    }
    $c++;
    draw();
    print "Seconds: ", $o + $c * $s, "\n";
    last if $c > 1000;
}

sub draw {
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $r = $r{"$x,$y"};
            print $r || ' ';
        }
        print "\n";
    }
}

# Cycle 101: 12 113 214 315 416 517 618 719 820 ...
# Cycle 103: 88 191 294 397 500 603 706 809 912 ...
# 101 * 103 = 10403
# lcm(101, 103) = 10403
