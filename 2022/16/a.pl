#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my %valves;
while (<>) {
    my ($name, $rate, $links) = /Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z][A-Z, ]*[A-Z])/ or die "Unrecognized input: $_";

    $valves{$name} = {rate => $rate, links => [split /\s*,\s*/, $links]};
}

my $valves = keys %valves;
print "$valves valves.\n";

my $flowvalves = grep $valves{$_}{rate} > 0, keys %valves;
print "$flowvalves valves has flow.\n";

# use Data::Dumper;
# print Dumper(\%valves);
# exit;

my @q = ['AA', 'AA', 0, 0, {}];
my $max = 0;
my $openmax = 0;
my $c = 0;
while (@q) {
    $c++;
    my $q = shift @q;
    my ($position, $origin, $time, $flow, $open) = @$q;
    my $valve = $valves{$position};
    my $remaining = 30 - $time;
    my $nopen = 0+keys %$open;
    my $optimal = sum $flow, map !$open->{$_} * $valves{$_}{rate} * ($remaining-1), keys %valves;

    print "i:$c, flow:$flow, opt:$optimal, max:$max, time:$time, open: $nopen, openmax:$openmax, q:", 0+@q, "\n" unless $c % 1_000_000;

    $max = $flow if $max < $flow;
    $openmax = $nopen if $openmax < $nopen;

    next if $remaining <= 0;
    next if $nopen >= $flowvalves;
    next if $optimal < $max;

    unshift @q => [$position, $position, $time+1, $flow + $valve->{rate} * ($remaining-1), { %$open, $position => 1 }] if !$open->{$position} && $valve->{rate} > 0;

    for my $link (sort { $open->{$a} <=> $open->{$b} || $valves{$b}{rate} <=> $valves{$a}{rate} } @{$valve->{links}}) {
        next if $link eq $origin;
        next if @{$valves{$link}{links}} == 1 && ($open->{$link} || $valves{$link}{rate} == 0);

        push @q => [$link, $position, $time+1, $flow, $open];
    }
}

print "Max flow: $max, after $c iterations.\n";
