#!/usr/bin/perl
use strict;
use List::MoreUtils qw(pairwise);

my @l = map { chomp; $_ } <>;
print 0+@l, " box IDs\n";
my $c;

loop:
foreach my $x (@l) {
    foreach my $y (@l) {
        $c++;
        my @x = split '', $x;
        my @y = split '', $y;
        # print "@x <=> @y, ";
        my $d = grep $_, pairwise { $a ne $b } @x, @y;
        # print "differs by $d letters\n";

        if ($d == 1) {
            print "$c compares\n";
            print "Common letters between $x and $y: ",
                join('', grep $_, pairwise { $a eq $b ? $a : '' } @x, @y), "\n";
            last loop;
        }
    }
}
