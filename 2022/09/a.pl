#!/usr/bin/perl
use strict;
use Math::Utils qw(sign);

my ($hx, $hy) = (0, 0);
my ($tx, $ty) = (0, 0);
my %t = ("$tx,$ty" => 1);
my %d = (
    U => {x => 0, y => -1},
    R => {x => 1, y => 0},
    D => {x => 0, y => 1},
    L => {x => -1, y => 0},
);

while (<>) {
    my ($d, $s) = /([URLD]) (\d+)/ or die $_;

    for (1..$s) {
        my ($mx, $my) = ($d{$d}{x}, $d{$d}{y});
        $hx += $mx;
        $hy += $my;

        my ($dx, $dy) = ($tx - $hx, $ty - $hy);

        if (abs($dx) >= 2 or abs($dy) >= 2) {
            $tx -= sign($dx);
            $ty -= sign($dy);
        }

        $t{"$tx,$ty"}++;

        # print "$d, H($hx,$hy) M($mx,$my) T($tx,$ty) D($dx,$dy)\n";
    }
}

my $c = keys %t;
print "Visited positions: $c\n";
