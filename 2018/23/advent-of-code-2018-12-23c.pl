#!/usr/bin/perl
use strict;
use List::Util qw(min max all);

my @bots;
while (<>) {
    push @bots => {
        x => 0+$1,
        y => 0+$2,
        z => 0+$3,
        r => 0+$4,
    } if /pos\s*=s*<\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*>\s*,\s*r\s*=\s*(\d+)/;
}

print "Number of bots: ", 0+@bots, "\n";

my @clusters;
for my $bot (@bots) {
    for my $cluster (@clusters) {
        push @$cluster => $bot if all {
            abs($bot->{x} - $_->{x}) +
            abs($bot->{y} - $_->{y}) +
            abs($bot->{z} - $_->{z}) <=
            $bot->{r} + $_->{r}
        } @$cluster;
    }
    push @clusters => [$bot];
}


my ($cluster) = sort { @$b <=> @$a } @clusters;

print "Largest cluster: ", 0+@$cluster, "\n";

for my $bot (@$cluster) {
    $bot->{d} = abs($bot->{x}) + abs($bot->{y}) + abs($bot->{z}) - $bot->{r};
}

my ($bot) = sort { $b->{d} <=> $a->{d} } @$cluster;

print "Furthest bot in cluster: <$bot->{x}, $bot->{y}, $bot->{z}>, r=$bot->{r}, d=$bot->{d}\n"

