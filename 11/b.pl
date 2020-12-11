#!/usr/bin/perl
use strict;
use List::Util qw(min max);
use Term::ANSIColor;

my ($x, $y) = (0, 0);
my %c;
while (<>) {
    chomp;
    $c{$x++ .','. $y} = $_ for split '';
    $y++;
    $x = 0;
}

my @x = map [split ',']->[0], keys %c;
my @y = map [split ',']->[1], keys %c;
my $xmin = min @x;
my $xmax = max @x;
my $ymin = min @y;
my $ymax = max @y;
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
print "Width: $w\n";
print "Height: $h\n";
print "Size: ", $w * $h, "\n";

print "After 0 rounds:\n";
draw();

my $i = 0;
while (++$i) {
    my %d;
    for my $py ($ymin .. $ymax) {
        my ($ny, $sy) = ($py-1, $py+1);
        for my $px ($xmin .. $xmax) {
            my ($wx, $ex) = ($px-1, $px+1);
            my $c = $c{"$px,$py"};

            sub p {
                my ($sx, $sy, $dx, $dy) = @_;
                my $v = '.';
                $v = $c{($sx+=$dx) .','. ($sy+=$dy)} while $v eq '.';
                return $v;
            }

            my @a = (
                p($px, $py, -1, -1),  p($px, $py, 0, -1),  p($px, $py, 1, -1),
                p($px, $py, -1,  0),                       p($px, $py, 1,  0),
                p($px, $py, -1,  1),  p($px, $py, 0,  1),  p($px, $py, 1,  1),
            );

            my $o = grep $_ eq '#', @a;

            if ($c eq 'L' and $o == 0) {
                $d{"$px,$py"} = '#';
            } elsif ($c eq '#' and $o >= 5) {
                $d{"$px,$py"} = 'L';
            } else {
                $d{"$px,$py"} = $c;
            }
        }
    }
    my $po = grep $_ eq '#', values %c;
    my $no = grep $_ eq '#', values %d;
    %c = %d;

    print "After $i rounds, $no occupied seats.\n";
    draw();

    if ($no == $po) {
        print "After $i rounds, $no occupied seats.\n";
        last;
    }
}

sub draw {
    for my $py ($ymin .. $ymax) {
        for my $px ($xmin .. $xmax) {
            my $c = $c{"$px,$py"};
            if ($c eq 'L') {
                print color('white', 'on_green'), ' L ';
            } elsif ($c eq '#') {
                print color('white', 'on_red'), ' # ';
            } elsif ($c eq '.') {
                print color('black', 'on_blue'), ' • ';
            }
        }
        print color('reset'), "\n";
    }
}
