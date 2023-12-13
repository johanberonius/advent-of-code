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

    my $fc = -1;
    for my $c (0..$width-1) {
        my $e = 0;
        for my $i (0..$width-1) {
            last if $c-$i < 0 || $c+$i+1 > $width-1;
            $e = 0;
            last unless $c[$c-$i] eq $c[$c+$i+1];
            $e = 1;
        }
        if ($e) {
            print "Original column $c is mirrored\n";
            $fc = $c;
            last;
        }
    }

    my $fr = -1;
    for my $r (0..$height-1) {
        my $e = 0;
        for my $i (0..$height-1) {
            last if $r-$i < 0 || $r+$i+1 > $height-1;
            $e = 0;
            last unless $r[$r-$i] eq $r[$r+$i+1];
            $e = 1;
        }
        if ($e) {
            print "Original row $r is mirrored\n";
            $fr = $r;
            last;
        }
    }

    grid: for my $y (0..$height-1) {
        for my $x (0..$width-1) {
            my $co = substr $c[$x], $y, 1;
            my $cc = $co eq '.' ? '#' : '.';
            substr $c[$x], $y, 1, $cc;

            my $ro = substr $r[$y], $x, 1;
            my $rc = $ro eq '.' ? '#' : '.';
            substr $r[$y], $x, 1, $rc;

            # print "Swapping tile at ($x, $y) from $co to $cc ($ro to $rc)\n";
            # print "Column: $c[$x]\n";
            # print "Row:    $r[$y]\n";

            for my $c (0..$width-1) {
                next if $c == $fc;
                my $e = 0;
                for my $i (0..$width-1) {
                    last if $c-$i < 0 || $c+$i+1 > $width-1;
                    $e = 0;
                    last unless $c[$c-$i] eq $c[$c+$i+1];
                    $e = 1;
                }
                if ($e) {
                    print "Column $c is mirrored\n";
                    $s += $c + 1;
                    last grid;
                }
            }

            for my $r (0..$height-1) {
                next if $r == $fr;
                my $e = 0;
                for my $i (0..$height-1) {
                    last if $r-$i < 0 || $r+$i+1 > $height-1;
                    $e = 0;
                    last unless $r[$r-$i] eq $r[$r+$i+1];
                    $e = 1;
                }
                if ($e) {
                    print "Row $r is mirrored\n";
                    $s += 100 * ($r + 1);
                    last grid;
                }
            }

            substr $c[$x], $y, 1, $co;
            substr $r[$y], $x, 1, $ro;
        }
    }
    print "\n";
    last if eof;
}
print "Sum: $s\n";
