#!/usr/bin/perl
use strict;

my @bots;
while (<>) {
    push @bots => {
        x => 0+$1,
        y => 0+$2,
        z => 0+$3,
        r => 0+$4,
    } if /pos\s*=s*<\s*(-?\d+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*>\s*,\s*r\s*=\s*(\d+)/;
}


my ($maxr) = sort { $b->{r} <=> $a->{r} } @bots;

print "Number of bots: ", 0+@bots, "\n";
print "Strongest bot: <$maxr->{x},$maxr->{y},$maxr->{z}>, r=$maxr->{r}\n";

my $in_range;
for my $bot (@bots) {
    my $d = abs($bot->{x} - $maxr->{x}) +
            abs($bot->{y} - $maxr->{y}) +
            abs($bot->{z} - $maxr->{z});
    $in_range++ if $d <= $maxr->{r};

    print "Bot: <$bot->{x},$bot->{y},$bot->{z}>, r=$bot->{r}, distance=$d\n";
}

print "Bots in range: $in_range\n";
