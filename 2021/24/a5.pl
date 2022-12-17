#!/usr/bin/perl
use strict;

# my $n = 99_999_999_999_999;

# Max: 93499629698999
my $n = 93_499_629_698_999;

# Min:
my $n = 11_164_118_121_471;

my @n = split '', $n;
my @s;
my $w;
my $n;

# Checks:
# 13, 12, 11,  0, 15, -13, 10, -9, 11, 13, -14, -3, -2, -14
# Offsets:
# 14,  8,  5,  4, 10,  13, 16,  5,  6, 13,   6,  7, 13,   3

$w = shift @n;
push @s => $w + 14;
print "1, n: $n, s: @s\n";

    $w = shift @n;
    push @s => $w + 8;
    print "2, n: $n, s: @s\n";

        # 3 & 4
        $w = shift @n;
        push @s => $w + 5;
        print "3, n: $n, s: @s\n";

        $n = pop(@s) + 0;
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            push @s => $w + 4;
        }
        print "4, n: $n, s: @s\n";

        # 5 & 6
        $w = shift @n;
        push @s => $w + 10;
        print "5, n: $n, s: @s\n";

        $n = pop(@s) - 13;
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            push @s => $w + 13;
        }
        print "6, n: $n, s: @s\n";

        # 7 & 8
        $w = shift @n;
        push @s => $w + 16;
        print "7, n: $n, s: @s\n";

        $n = pop(@s) - 9;
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            push @s => $w + 5;
        }
        print "8, n: $n, s: @s\n";


        $w = shift @n;
        push @s => $w + 6;
        print "9, n: $n, s: @s\n";

            # 10 & 11
            $w = shift @n;
            push @s => $w + 13;
            print "10, n: $n, s: @s\n";

            $n = pop(@s) - 14;
            $w = shift @n;
            if ($n != $w) {
                print "/\n";
                push @s => $w + 6;
            }
            print "11, n: $n, s: @s\n";

        # 9 & 12
        $n = pop(@s) - 3;
        $w = shift @n;
        if ($n != $w) {
            print "/\n";
            push @s => $w + 7;
        }
        print "12, n: $n, s: @s\n";

    # 2 & 13
    $n = pop(@s) - 2;
    $w = shift @n;
    if ($n != $w) {
        print "/\n";
        push @s => $w + 13;
    }
    print "13, n: $n, s: @s\n";

# 1 & 14
$n = pop(@s) - 14;
$w = shift @n;
if ($n != $w) {
    print "/\n";
    push @s => $w + 3;
}
print "14, n: $n, s: @s\n";
