#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my %g;
while (<>) {
    /(\d+),(\d+)/ or last;
    $g{"$1,$2"} = '#';
}

my @f;
while (<>) {
    push @f => [$1, $2] if /fold.*(x|y)=(\d+)/;
}

my ($xmin, $xmax);
my ($ymin, $ymax);
my ($w, $h);

sub draw {
    my @x = map { (split ',')[0] } keys %g;
    my @y = map { (split ',')[1] } keys %g;
    $xmin = min @x;
    $xmax = max @x;
    $ymin = min @y;
    $ymax = max @y;
    $w = $xmax - $xmin + 1;
    $h = $ymax - $ymin + 1;

    print "Map size: $w x $h\n";
    print "Visible dots: ", 0+values %g ,"\n";
    for my $y ($ymin..$ymax) {
        for my $x ($xmin..$xmax) {
            print $g{"$x,$y"} ? (color('on_black'), '#', color('reset')) : '.';
        }
        print "\n";
    }
    print "\n";
}

draw();

for my $f (@f) {
    print "fold along $f->[0]=$f->[1]\n";

    if ($f->[0] eq 'y') {
        for my $y ($ymin..$f->[1]-1) {
            for my $x ($xmin..$xmax) {
                $g{"$x,$y"} = '#' if $g{"$x,".($ymax-$y)};
            }
        }
        for my $y ($f->[1]..$ymax) {
            for my $x ($xmin..$xmax) {
                delete $g{"$x,$y"};
            }
        }
    } elsif ($f->[0] eq 'x') {
        for my $y ($ymin..$ymax) {
            for my $x ($xmin..$f->[1]-1) {
                $g{"$x,$y"} = '#' if $g{($xmax-$x).",$y"};
            }
            for my $x ($f->[1]..$xmax) {
                delete $g{"$x,$y"};
            }
        }
    }

    draw();
}
