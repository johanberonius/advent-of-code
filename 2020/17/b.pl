#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my ($x, $y, $z, $w) = (0, 0, 0, 0);
my %c;
while (<>) {
    chomp;
    $c{$x++ .",$y,$z,$w"} = $_ for split '';
    $y++;
    $x = 0;
}

my $i = 0;
while (1) {
    my @x = map [split ',']->[0], keys %c;
    my @y = map [split ',']->[1], keys %c;
    my @z = map [split ',']->[2], keys %c;
    my @w = map [split ',']->[3], keys %c;
    my ($xmin, $xmax) = (min(@x), max(@x));
    my ($ymin, $ymax) = (min(@y), max(@y));
    my ($zmin, $zmax) = (min(@z), max(@z));
    my ($wmin, $wmax) = (min(@w), max(@w));
    my $w = $xmax - $xmin + 1;
    my $h = $ymax - $ymin + 1;
    my $d = $zmax - $zmin + 1;
    my $q = $wmax - $wmin + 1;
    print "Width: $w\n";
    print "Height: $h\n";
    print "Depth: $d\n";
    print "4d-span: $q\n";
    print "Hypercube size: ", $w * $h * $d * $q, "\n";

    my $na = grep $_ eq '#', values %c;
    print "After $i cycles, $na cubes active.\n\n";

    last if ++$i > 6;

    my %d;
    for my $pw ($wmin-1 .. $wmax+1) {
        for my $pz ($zmin-1 .. $zmax+1) {
            for my $py ($ymin-1 .. $ymax+1) {
                for my $px ($xmin-1 .. $xmax+1) {
                    my $cc = "$px,$py,$pz,$pw";
                    my $c = $c{$cc};

                    my $n = 0;
                    for my $nw ($pw-1..$pw+1) {
                        for my $nz ($pz-1..$pz+1) {
                            for my $ny ($py-1..$py+1) {
                                for my $nx ($px-1..$px+1) {
                                    my $nc = "$nx,$ny,$nz,$nw";
                                    next if $nc eq $cc;
                                    $n++ if $c{$nc} eq '#';
                                }
                            }
                        }
                    }

                    if ($c eq '#' and $n < 2 || $n > 3) {
                        $d{"$px,$py,$pz,$pw"} = '.';
                    } elsif ($c ne '#' and $n == 3) {
                        $d{"$px,$py,$pz,$pw"} = '#';
                    } else {
                        $d{"$px,$py,$pz,$pw"} = $c;
                    }
                }
            }
        }
    }
    %c = %d;
}
