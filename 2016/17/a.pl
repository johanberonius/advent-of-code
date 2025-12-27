#!/usr/bin/perl
use strict;
use Digest::MD5 qw(md5_hex);

#my $s = "hijkl";
# my $s = "ihgpwlah";
# my $s = "kglvqrro";
# my $s = "ulqzkmiv";
my $s = "pvhmgsws";

my @q = ([0, 0, '']);
my %s;
my $i = 0;
while (@q) {
    my $q = shift @q;
    my ($x, $y, $p) = @$q;

    next if $s{"$x,$y,$p"}++;

    if ($x == 3 && $y == 3) {
        print "Shortest path: $p\n";
        last;
    }

    my ($u, $d, $l, $r) = map 0+/[bcdef]/, split '', md5_hex("$s$p");

    push @q => [$x, $y+1, $p.'D'] if $y < 3 && $d;
    push @q => [$x+1, $y, $p.'R'] if $x < 3 && $r;
    push @q => [$x, $y-1, $p.'U'] if $y > 0 && $u;
    push @q => [$x-1, $y, $p.'L'] if $x > 0 && $l;
}
