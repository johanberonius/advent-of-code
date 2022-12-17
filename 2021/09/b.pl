#!/usr/bin/perl
use strict;

my ($w, $h) = (0, 0);
my %d;
while (<>) {
    chomp;
    $w = 0;
    $d{$w++ .','. $h} = 0+$_ for split '';
    $h++;
}

print "Depth map, width: $w, height: $h\n";

my %s;
for my $y (0..$h-1) {
    for my $x (0..$w-1) {
        my ($n, $s) = ("$x,". ($y-1), "$x,". ($y+1));
        my ($w, $e) = (($x-1) .",$y", ($x+1) .",$y");
        my $d = $d{"$x,$y"};

        if (!defined $d{$n} || $d{$n} > $d and
            !defined $d{$s} || $d{$s} > $d and
            !defined $d{$e} || $d{$e} > $d and
            !defined $d{$w} || $d{$w} > $d) {

            print "Low point at x: $x, y: $y\n";
            my %b;
            my $s = 0;
            my @p = ("$x,$y");
            while (@p) {
                my $p = shift @p;
                if (!$b{$p}++ and defined $d{$p} and $d{$p} < 9) {
                    $s++;
                    my ($px, $py) = split ',', $p;
                    push @p => (
                        "$px,". ($py-1), "$px,". ($py+1),
                        ($px-1) .",$py", ($px+1) .",$py"
                    );
                }
            }
            $s{"$x,$y"} = $s;
        }
    }
}

print "Basin sizes:\n", map("$_: $s{$_}\n", keys %s);

my @s = sort { $b <=> $a } values %s;
print "Product of three largest: ", $s[0] * $s[1] * $s[2], "\n";
