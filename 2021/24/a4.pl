#!/usr/bin/perl
use strict;

# my $n = 99_999_999_999_999;

# Max: 93499629698999
my $n = 93_499_629_698_999;

# Min: 11164118121471
my $n = 11_164_118_121_471;

my @n = split '', $n;
my ($w, $z, $n);

# Checks:
# 13, 12, 11,  0, 15, -13, 10, -9, 11, 13, -14, -3, -2, -14
# Offsets:
# 14,  8,  5,  4, 10,  13, 16,  5,  6, 13,   6,  7, 13,   3

$w = shift @n;
$z = $w + 14;
print "1, n: $n, z: $z\n";

    $w = shift @n;
    $z = $z * 26 + $w + 8;
    print "2, n: $n, z: $z\n";

        # 3 & 4
        $w = shift @n;
        $z = $z * 26 + $w + 5;
        print "3, n: $n, z: $z\n";

        $n = $z % 26 + 0;
        $z = int($z / 26);
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            $z = $z * 26 + $w + 4;
        }
        print "4, n: $n, z: $z\n";

        # 5 & 6
        $w = shift @n;
        $z = $z * 26 + $w + 10;
        print "5, n: $n, z: $z\n";

        $n = $z % 26 - 13;
        $z = int($z / 26);
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            $z = $z * 26 + $w + 13;
        }
        print "6, n: $n, z: $z\n";

        # 7 & 8
        $w = shift @n;
        $z = $z * 26 + $w + 16;
        print "7, n: $n, z: $z\n";

        $n = $z % 26 - 9;
        $z = int($z / 26);
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            $z = $z * 26 + $w + 5;
        }
        print "8, n: $n, z: $z\n";


        $w = shift @n;
        $z = $z * 26 + $w + 6;
        print "9, n: $n, z: $z\n";

            # 10 & 11
            $w = shift @n;
            $z = $z * 26 + $w + 13;
            print "10, n: $n, z: $z\n";

            $n = $z % 26 - 14;
            $z = int($z / 26);
            $w = shift @n;
            if ($n != $w) {
                print "/\n";
                $z = $z * 26 + $w + 6;
            }
            print "11, n: $n, z: $z\n";

        # 9 & 12
        $n = $z % 26 - 3;
        $z = int($z / 26);
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            $z = $z * 26 + $w + 7;
        }
        print "12, n: $n, z: $z\n";

    # 2 & 13
    $n = $z % 26 - 2;
    $z = int($z / 26);
    $w = shift @n;
    if ($n != $w) {
        print "/\n";
        $z = $z * 26 + $w + 13;
    }
    print "13, n: $n, z: $z\n";

# 1 & 14
$n = $z % 26 - 14;
$z = int($z / 26);
$w = shift @n;
if ($n != $w) {
    print "/\n";
    $z = $z * 26 + $w + 3;
}
print "14, n: $n, z: $z\n";
