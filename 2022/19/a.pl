#!/usr/bin/perl
use strict;
use List::Util qw(max);

my @blueprints;
while (<>) {
    push @blueprints => [
        [$1,  0,  0],
        [$2,  0,  0],
        [$3, $4,  0],
        [$5,  0, $6],
    ] if
    /Blueprint \d+: Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./
    or die "Unrecognized input: $_\n";
}

my $tql = 0;
for my $id (1..@blueprints) {
    my $costs = $blueprints[$id-1];
    my @maxcosts = (
        max(map $costs->[$_][0], 0..3),
        max(map $costs->[$_][1], 0..3),
        max(map $costs->[$_][2], 0..3),
    );
    my @q = [0,  [1, 0, 0, 0],  [-1, 0, 0, 0]];
    my $max = 0;
    my %seen;
    while (@q) {
        my $q = shift @q;
        my ($time, $robots, $items) = @$q;

        @$items = map $items->[$_] + $robots->[$_], 0..3;

        next if $seen{"@$robots @$items"}++;

        next if $max-1 > $items->[3];

        $max = $items->[3] if $max <= $items->[3];

        next if ++$time > 24;

        push @q => [$time, [@$robots], [@$items]];

        for my $type (0..3) {
            next if $maxcosts[$type] && $robots->[$type] >= $maxcosts[$type];

            if ($items->[0] >= $costs->[$type][0] &&
                $items->[1] >= $costs->[$type][1] &&
                $items->[2] >= $costs->[$type][2]) {

                my @robots = @$robots;
                $robots[$type]++;
                my @items = (
                    $items->[0] - $costs->[$type][0],
                    $items->[1] - $costs->[$type][1],
                    $items->[2] - $costs->[$type][2],
                    $items->[3],
                );
                $items[$type]--;
                push @q => [$time, [@robots], [@items]];
            }
        }
    }

    my $ql = $id * $max;
    $tql += $ql;
    print "Blueprint $id, max geodes $max, quality level: $ql\n";
}

print "Total quality level: $tql\n";
