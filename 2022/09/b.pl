#!/usr/bin/perl
use strict;
use Math::Utils qw(sign);

my @t = map {x => 0, y => 0}, 0..9;
my %t = ("0,0" => 1);
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
        $t[0]{x} += $mx;
        $t[0]{y} += $my;
        # print "$d, H($t[0]{x},$t[0]{y}) M($mx,$my)\n";

        for my $i (1..9) {
            my ($dx, $dy) = ($t[$i]{x} - $t[$i-1]{x}, $t[$i]{y} - $t[$i-1]{y});

            if (abs($dx) >= 2 or abs($dy) >= 2) {
                $t[$i]{x} -= sign($dx);
                $t[$i]{y} -= sign($dy);
            }
            # print "    T$i($t[$i]{x},$t[$i]{y}) D($dx,$dy)\n";
        }

        $t{"$t[9]{x},$t[9]{y}"}++;
    }
}

my $c = keys %t;
print "Visited positions: $c\n";
