#!/usr/bin/perl
use strict;

my @r = (3, 7);
my $c1 = 0;
my $c2 = 1;

# my $r = '01245';
my $r = '51589';
# my $r = '92510';
# my $r = '59414';
# my $r = '047801';
my $i = 0;

use Time::HiRes qw(time);
my $t = time;

while () {
    print 0+@r, ": @r\n";

    unless ($i % 1000_000) {
        printf "$i: %18d, %18d, %18d\n", 0+@r, $c1, $c2;
        print 1000_000 / (time - $t), "/s.\n";
        $t = time;
    }

    last if @r >= 20;
    # last if join('', @r[-length($r)..-1]) eq $r;
    last if
        $r[-6] == 0 &&
        $r[-5] == 4 &&
        $r[-4] == 7 &&
        $r[-3] == 8 &&
        $r[-2] == 0 &&
        $r[-1] == 1;

    my $n = $r[$c1] + $r[$c2];
    push @r => 1 if $n >= 10;

    last if
        $r[-6] == 0 &&
        $r[-5] == 4 &&
        $r[-4] == 7 &&
        $r[-3] == 8 &&
        $r[-2] == 0 &&
        $r[-1] == 1;

    push @r => $n % 10;
    $c1 = ($c1 + 1 + $r[$c1]) % @r;
    $c2 = ($c2 + 1 + $r[$c2]) % @r;
    $i++;
}

print "$i iterations\n";
print "Number of recipies before '@r[-length($r)..-1]': ", @r-length($r), "\n";
