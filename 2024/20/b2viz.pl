#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my %g;
my ($x, $y) = (0, 0);
my ($width, $height);
my ($sx, $sy);
my ($ex, $ey);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        if ($g eq 'S') {
            ($sx, $sy) = ($x, $y);
            $g = '.';
        } elsif ($g eq 'E') {
            ($ex, $ey) = ($x, $y);
            $g = '.';
        }
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

print "\n";

my %c;
my $m;

my @q = [$sx, $sy, 0];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $c) = @$q;

    my $k = "$x,$y";
    next if exists $c{$k} && $c{$k} <= $c;
    $c{$k} = $c;

    if ($x == $ex && $y == $ey) {
        $m = $c;
        last;
    }

    my ($w, $e) = ($x-1, $x+1);
    my ($n, $s) = ($y-1, $y+1);
    push @q => [$w, $y, $c+1] if $g{"$w,$y"} eq '.';
    push @q => [$e, $y, $c+1] if $g{"$e,$y"} eq '.';
    push @q => [$x, $n, $c+1] if $g{"$x,$n"} eq '.';
    push @q => [$x, $s, $c+1] if $g{"$x,$s"} eq '.';

    draw();
}


my %s;
my $md = 2;
for (sort { $c{$a} <=> $c{$b} } keys %c) {
    my ($ox, $oy) = split ',';
    my $sc = $c{$_};
    %s = ();

    for my $x ($ox-$md..$ox+$md) {
        for my $y ($oy-$md..$oy+$md) {
            my $d = abs($x-$ox) + abs($y-$oy);
            my $dc = $c{"$x,$y"};
            $s{"$x,$y"} = '.' if $d <= $md;
            if ($dc && $d <= $md) {
                my $s = $dc - $sc - $d;
                $s{"$x,$y"} = $s if $s > 0;
            }

        }
    }

    draw();
    sleep 0.2;
}


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $c = $c{"$x,$y"};
            my $s = $s{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('on_rgb411'), " S ", color('reset');
            } elsif ($x == $ex && $y == $ey) {
                print color('on_rgb131'), " E ", color('reset');
            } elsif ($s > 0 && $c) {
                print color('on_rgb422');
                printf "-%-2d", $s;
                print color('reset');
            } elsif ($s && $c) {
                print color('on_rgb224'), " • ", color('reset');
            } elsif ($c) {
                print color('on_rgb114'), " • ", color('reset');
            } elsif ($s && $g eq '#') {
                print color('on_rgb121'), "   ", color('reset');
            } elsif ($g eq '#') {
                print color('on_rgb111'), "   ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    print "\n";
    $lines++;
    sleep 0.02;
}
