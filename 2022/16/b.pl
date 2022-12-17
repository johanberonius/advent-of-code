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

for my $valve (values %valves) {
    $valve->{links} = [sort { $valves{$a}{rate} <=> $valves{$b}{rate} } @{$valve->{links}}];
}

my @q = ['AA', 'AA', 0, 0, {}];
my %v;
my $max = 0;
my $maxref;
my $openmax = 0;
my $c = 0;
while (@q) {
    $c++;
    my $q = shift @q;
    my ($pos1, $pos2, $time, $flow, $open) = @$q;
    my $valve1 = $valves{$pos1};
    my $valve2 = $valves{$pos2};
    my $remaining = 26 - $time;
    my $nopen = 0+keys %$open;
    my $optimal = sum $flow, map !$open->{$_} * $valves{$_}{rate} * ($remaining-1), keys %valves;

    print "i:$c, flow:$flow, opt:$optimal, max:$max, time:$time, open: $nopen, openmax:$openmax, q:", 0+@q, "\n" unless $c % 100_000 && @q;

    if ($max < $flow) {
        $maxref = $q;
        $max = $flow;
    }
    $openmax = $nopen if $openmax < $nopen;

    my $key = join(',', sort $pos1, $pos2) .'-'. join(',', sort keys %$open);
    # print "key:$key, time:$time, v:$v{$key}\n";
    next if exists $v{$key} && $v{$key} >= $flow;
    $v{$key} = $flow;

    next if $remaining <= 0;
    next if $nopen >= $flowvalves;
    next if $optimal <= $max;


    if (!$open->{$pos1} && $valve1->{rate} > 0 &&
        !$open->{$pos2} && $valve2->{rate} > 0 &&
        $pos1 ne $pos2) {
        unshift @q => [$pos1, $pos2, $time+1, $flow + $valve1->{rate} * ($remaining-1) + $valve2->{rate} * ($remaining-1), { %$open, $pos1 => 1, $pos2 => 1 }, $q];
    }

    if (!$open->{$pos1} && $valve1->{rate} > 0) {
        for my $link2 (@{$valve2->{links}}) {
            unshift @q => [$pos1, $link2, $time+1, $flow + $valve1->{rate} * ($remaining-1), { %$open, $pos1 => 1 }, $q];
        }
    }

    if (!$open->{$pos2} && $valve2->{rate} > 0) {
        for my $link1 (@{$valve1->{links}}) {
            unshift @q => [$link1, $pos2, $time+1, $flow + $valve2->{rate} * ($remaining-1), { %$open, $pos2 => 1 }, $q];
        }
    }

    for my $link1 (@{$valve1->{links}}) {
        for my $link2 (@{$valve2->{links}}) {
            push @q => [$link1, $link2, $time+1, $flow, $open, $q];
        }
    }
}

print "Max flow: $max, after $c iterations.\n";

print "Path:\n";
my $ref = $maxref;
while ($ref) {
    my ($pos1, $pos2, $time, $flow, $open, $parent) = @$ref;
    my $released = sum map $valves{$_}{rate}, keys %$open;
    print "$pos1, $pos2, time: $time, flow: $flow, open: @{[sort keys %$open]}, released: $released\n";
    $ref = $parent;
}

# 2497 too low
# 2521 too low
# 2599 too low
# 2680 not correct
# 2804 not correct
# 2818 not correct
# 2838 is correct!
