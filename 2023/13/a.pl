#!/usr/bin/perl
use strict;

my $s = 0;

while(1) {
    my @r;
    my @c;
    my ($x, $y) = (0, 0);
    my ($width, $height);
    while (<>) {
        chomp;
        last unless $_;
        push @r => $_;
        $x = 0;
        for my $e (split '') {
            $c[$x] .= $e;
            $x++;
        }
        $width = $x if $x > $width;
        $y++;
    }
    $height = $y;

    print "Grid width: $width, height: $height\n";

    for my $x (0..$width-1) {
        my $e = 0;
        for my $i (0..$width-1) {
            last if $x-$i < 0 || $x+$i+1 > $width-1;
            $e = 0;
            last unless $c[$x-$i] eq $c[$x+$i+1];
            $e = 1;
        }
        if ($e) {
            print "Column $x is mirrored\n";
            $s += $x + 1;
        }
    }

    for my $y (0..$height-1) {
        my $e = 0;
        for my $i (0..$height-1) {
            last if $y-$i < 0 || $y+$i+1 > $height-1;
            $e = 0;
            last unless $r[$y-$i] eq $r[$y+$i+1];
            $e = 1;
        }
        if ($e) {
            print "Row $y is mirrored\n";
            $s += 100 * ($y + 1);
        }
    }
    print "\n";
    last if eof;
}
print "Sum: $s\n";
