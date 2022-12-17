#!/usr/bin/perl
use strict;

chomp(my $a = <>);
my @a = map { $_ eq '#' || 0 } split '', $a;

my ($w, $h) = (0, 0);
my %i;
while (<>) {
    chomp;
    next unless $_;
    $w = 0;
    $i{$w++ .','. $h} = $_ for map { $_ eq '#' || 0 } split '';
    $h++;
}

my ($xmin, $xmax) = (0, $w-1);
my ($ymin, $ymax) = (0, $h-1);

my $s = 0;
while (1) {
    print "After step: $s\n";
    print "Image width: ", ($xmax-$xmin+1), ", height: ", ($ymax-$ymin+1),"\n";
    my $p = grep $_, values %i;
    print "Lit pixels: $p\n";
    print "\n";

    last if $s >= 50;

    $xmin--;
    $xmax++;
    $ymin--;
    $ymax++;
    my %j;

    if ($a[0] && $s % 2) {
        print "Step: $s, filling borders\n";
        for my $y ($ymin-1..$ymax+1) {
            for my $x ($xmin-1, $xmin, $xmax, $xmax+1) {
                $i{"$x,$y"} = 1;
            }
        }

        for my $x ($xmin-1..$xmax+1) {
            for my $y ($ymin-1, $ymin, $ymax, $ymax+1) {
                $i{"$x,$y"} = 1;
            }
        }
    }

    for my $y ($ymin..$ymax) {
        for my $x ($xmin..$xmax) {
            my ($n, $s) = ($y-1, $y+1);
            my ($w, $e) = ($x-1, $x+1);

            my $b = '0b' . join '', map { $_ || 0 } @i{
                "$w,$n", "$x,$n", "$e,$n",
                "$w,$y", "$x,$y", "$e,$y",
                "$w,$s", "$x,$s", "$e,$s",
            };
            my $o = eval $b;
            $j{"$x,$y"} = $a[$o];

            # print $j{"$x,$y"} ? '#' : '.';
        }
        # print "\n";
    }
    # print "\n";
    %i = %j;
    $s++;
}
