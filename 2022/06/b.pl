#!/usr/bin/perl
use strict;
use List::Util qw(uniq);

my %tests = (
    mjqjpqmgbljsphdztnvjfqwrcgsmlb => 19,
    bvwbjplbgvbhsrlpgdmjqwftvncz => 23,
    nppdvjthqldpwncqszvftbrmjlhg => 23,
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg => 29,
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw => 26,
    <> => '?',
);

while (my ($s, $c) = each %tests) {
    my @s = split '', $s;

    print "$s => $c";
    my $i = 14;
    $i++ until $i > $#s || uniq(@s[$i-14..$i-1]) == 14;

    print " => $i\n";
}
