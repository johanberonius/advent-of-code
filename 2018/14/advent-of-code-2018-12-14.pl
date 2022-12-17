#!/usr/bin/perl
use strict;

my @r = ('3', '7');
my $c1 = 0;
my $c2 = 1;

# my $i = 5;
# my $i = 9;
# my $i = 18;
# my $i = 2018;
my $i = 47801;

while () {
    # print 0+@r, ": @r\n";

    last if @r >= $i + 10;

    my $n = $r[$c1] + $r[$c2];
    push @r => 1 if $n >= 10;
    push @r => $n % 10;
    $c1 = ($c1 + 1 + $r[$c1]) % @r;
    $c2 = ($c2 + 1 + $r[$c2]) % @r;
}

print "Next ten after the first $i recipies: ", @r[$i..$i+9], "\n";
