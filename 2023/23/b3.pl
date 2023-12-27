#!/usr/bin/perl
use strict;
use List::Util qw(max any);
use Term::ANSIColor;
use Time::HiRes qw(sleep);


my %g;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        $g = '.' if any { $g eq $_ } qw(> < ^ v);
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;

my ($sx, $sy) = (1, 0);
my ($ex, $ey) = ($width - 2, $height - 1);

print "Grid width: $width, height: $height\n";
print "Start position: $sx, $sy\n";
# draw();

my %s;
my %t;
my $m;
my $i = 0;
my @q = [$sx, $sy, "0 ", {}];
while (@q) {
    my $q = shift @q;
    my ($x, $y, $s, $v, $tx, $ty, $ts, $np, $lp) = @$q;
    $i++;

    my $p = "$x,$y";

    next if $v->{$p};
    $s{$p} = $v->{$p} = $s;

    my $t = $t{$p};
    if ($t && $ts == 1) {
        my ($dx, $dy, $ds) = @$t;
        unshift @q => [$dx, $dy, $s + $ds - 1, {%$v}];
        next;
    }

    my $g = $g{$p};
    next unless $g eq '.';


    if ($x == $ex && $y == $ey && $m < $s) {
        $m = $s;
        print "Found new max steps: $m\n";
    }

    my ($ny, $sy) = ($y-1, $y+1);
    my ($wx, $ex) = ($x-1, $x+1);

    my $pn = "$x,$ny";
    my $pe = "$ex,$y";
    my $ps = "$x,$sy";
    my $pw = "$wx,$y";

    my $gn = $g{$pn};
    my $ge = $g{$pe};
    my $gs = $g{$ps};
    my $gw = $g{$pw};

    my $vn = $v->{$pn};
    my $ve = $v->{$pe};
    my $vs = $v->{$ps};
    my $vw = $v->{$pw};

    my $exits = grep $_ eq '.', ($gn, $ge, $gs, $gw);
    if ($exits > 2 && $tx && $ty) {
        $t{"$tx,$ty"} = [$x, $y, $ts];
        $t{$lp} = [split(',', $np), $ts];
    }
    if ($exits > 2) {
        ($tx, $ty) = (0, 0);
        $ts = 0;
        $np = $p;
    }

    $s++;
    $ts++;
    unshift @q => [$ex, $y, $s, {%$v}, $tx || $ex, $ty || $y, $ts, $np, $p] if $ge eq '.' && !$ve;
    unless ($x == 113 && $y == 137) { # input, only go east to exit.
    # unless ($x == 19 && $y == 19) { # test1, only go south to exit.
        unshift @q => [$x, $sy, $s, {%$v}, $tx || $x, $ty || $sy, $ts, $np, $p] if $gs eq '.' && !$vs;
        unshift @q => [$x, $ny, $s, {%$v}, $tx || $x, $ty || $ny, $ts, $np, $p] if $gn eq '.' && !$vn;
        unshift @q => [$wx, $y, $s, {%$v}, $tx || $wx, $ty || $y, $ts, $np, $p] if $gw eq '.' && !$vw;
    }

    print "Iterations: $i, queue: ", 0+@q, "\n" unless $i % 10_000;
    # draw();
}

print "Iterations: $i\n";
print "Max steps: $m\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};
            my $s = $s{"$x,$y"};
            my $t = $t{"$x,$y"};

            if ($x == $sx && $y == $sy) {
                print color('on_rgb114'), " • ", color('reset');
            } elsif ($s) {
                print color($t ? 'on_rgb411' : 'on_rgb114');
                printf "%-3d", $t ? $t->[2] : $s;
                print color('reset');
            } elsif ($g eq '#') {
                print color('on_rgb111'), "   ", color('reset');
            } elsif ($g eq 'O') {
                print color('on_rgb114'), " • ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
    # sleep 0.05;
}
