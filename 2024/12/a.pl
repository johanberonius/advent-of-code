#!/usr/bin/perl
use strict;
use Term::ANSIColor;

my %g;
my %r;
my ($x, $y) = (0, 0);
my ($width, $height);

while (<>) {
    chomp;
    $x = 0;
    for my $g (split '') {
        $g{"$x,$y"} = $g;
        $x++;
    }
    $width = $x if $x > $width;
    $y++;
}
$height = $y;
print "Grid width: $width, height: $height\n";

draw();

my $s = 0;
for my $y (0..$height-1) {
    for my $x (0..$width-1) {
        next if $r{"$x,$y"};

        my $g = $g{"$x,$y"};
        print "Found region: $g, ";

        my $a = 0;
        my $p = 0;
        my @q = [$x, $y];
        while (@q) {
            my ($rx, $ry) = @{shift @q};
            next if $r{"$rx,$ry"};
            my $rg = $g{"$rx,$ry"};
            next unless $rg eq $g;

            my ($rw, $re) = ($rx-1, $rx+1);
            my ($rn, $rs) = ($ry-1, $ry+1);

            $r{"$rx,$ry"}++;
            $a++;
            $p++ unless $g{"$rw,$ry"} eq $rg;
            $p++ unless $g{"$rx,$rn"} eq $rg;
            $p++ unless $g{"$re,$ry"} eq $rg;
            $p++ unless $g{"$rx,$rs"} eq $rg;

            push @q => [$rw, $ry], [$rx, $rn], [$re, $ry], [$rx, $rs];
        }

        print "area: $a, perimeter: $p, fence price: ", $a * $p, "\n";
        $s += $a * $p;
    }
}

print "Total fence price: $s\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $g = $g{"$x,$y"};

            if ($g ne '.') {
                print color('on_rgb113'), " $g ", color('reset');
            } elsif ($g eq '.') {
                print color('on_rgb333'), " • ", color('reset');
            } else {
                print color('on_rgb333'), " $g ", color('reset');
            }
        }
        print "\n";
        $lines++;
    }
}
