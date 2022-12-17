#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my ($x, $y) = (0, 0);
my %c;
while (<>) {
    chomp;
    $x = 0;
    for my $c (split '') {
        $c{"$x,$y"} = $c;
        $x++;
    }
    $y++;
}

my ($o) = grep $c{$_} eq 'O', keys %c;
my ($ox, $oy) = split ',', $o;

my @p = ([$ox, $oy]);
while (@p) {
    my $p = shift @p;
    my ($x, $y) = @$p;
    my $d = 1+$c{"$x,$y"};
    my ($n, $s) = ($y - 1, $y + 1);
    my ($w, $e) = ($x - 1, $x + 1);

    if ($c{"$x,$n"} eq '.') {
        $c{"$x,$n"} = $d;
        push @p => [$x, $n];
    }

    if ($c{"$x,$s"} eq '.') {
        $c{"$x,$s"} = $d;
        push @p => [$x, $s];
    }

    if ($c{"$w,$y"} eq '.') {
        $c{"$w,$y"} = $d;
        push @p => [$w, $y];
    }

    if ($c{"$e,$y"} eq '.') {
        $c{"$e,$y"} = $d;
        push @p => [$e, $y];
    }

    draw();
}

my $m = max values %c;
print "Oxygen takes $m minutes to fill area.\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;

    my @x = map [split ',']->[0], keys %c;
    my @y = map [split ',']->[1], keys %c;
    my $w = max(@x) - min(@x) + 1;
    my $h = max(@y) - min(@y) + 1;
    print "Width: $w\n";
    $lines++;
    print "Height: $h\n";
    $lines++;
    print "Size: ", $w * $h, "\n";
    $lines++;
    print "Oxygen tank position: $ox,$oy\n";
    $lines++;


    for my $py (min(@y) .. max(@y)) {
        for my $px (min(@x) .. max(@x)) {
            my $b = $c{"$px,$py"};
            print color('on_black'), '   ' if  $b eq '#';
            print color('on_blue'), ' O ' if  $b eq 'O';
            print color('on_red'), '   ' if $b eq ' ';
            print color('on_green'), ' . ' if $b eq '.';
            print color('on_blue'), sprintf '%3d', $b if $b > 0;
            print color('reset'), '   ' unless $b;
        }
        print color('reset'), "\n";
        $lines++;
    }

    # sleep 0.01;
}
