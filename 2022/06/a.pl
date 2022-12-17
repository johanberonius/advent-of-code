#!/usr/bin/perl
use strict;
use List::Util qw(uniq);

my %tests = (
    mjqjpqmgbljsphdztnvjfqwrcgsmlb => 7,
    bvwbjplbgvbhsrlpgdmjqwftvncz => 5,
    nppdvjthqldpwncqszvftbrmjlhg => 6,
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg => 10,
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw => 11,
    <> => '?',
);

while (my ($s, $c) = each %tests) {
    my @s = split '', $s;

    print "$s => $c";
    my $i = 4;
    $i++ until $i > $#s || uniq(@s[$i-4..$i-1]) == 4;

    print " => $i\n";
}
