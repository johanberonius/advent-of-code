#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use List::Util qw(max);

my $root = { };
my $tip = $root;
my @branch;

my $steps = 0;
my $groups = 0;
my $branches = 0;
for (split '', <>) {
    if (/^([NESW])$/) {
        my $node = { dir => $1 };
        push @{$tip->{children}} => $node;
        $tip = $node;
        $steps++;
    } elsif ($_ eq '(') {
        push @branch => $tip;
        $groups++;
    } elsif ($_ eq '|') {
        push @{$branch[-1]{tips}} => $tip;
        $tip = $branch[-1];
        $branches++;
    } elsif ($_ eq ')') {
        push @{$branch[-1]{tips}} => $tip;
        $tip = { };
        push @{$_->{children}} => $tip for @{$branch[-1]{tips}};
        pop @branch;
        $branches++;
    }
}

print "Regex steps: $steps, groups: $groups, branches: $branches\n";


my %map;
my $nodes = 0;
tracemap($root, 0, 0);

sub tracemap {
    my ($node, $x, $y) = @_;

    return if $node->{visited};
    $node->{visited} = 1;
    $nodes++;

    if ($node->{dir} eq 'E') {
        $x++;
        $map{"$x,$y"} = '|';
        $x++;
    } elsif ($node->{dir} eq 'W') {
        $x--;
        $map{"$x,$y"} = '|';
        $x--;
    } elsif ($node->{dir} eq 'S') {
        $y++;
        $map{"$x,$y"} = '-';
        $y++;
    } elsif ($node->{dir} eq 'N') {
        $y--;
        $map{"$x,$y"} = '-';
        $y--;
    }

    $map{"$x,$y"} = '.';

    tracemap($_, $x, $y) for @{$node->{children}};
}


my @x = sort { $a <=> $b } map [split ',']->[0], keys %map;
my @y = sort { $a <=> $b } map [split ',']->[1], keys %map;
my $xmin = $x[0];
my $xmax = $x[-1];
my $ymin = $y[0];
my $ymax = $y[-1];
my $width = ($xmax - $xmin + 2) / 2;
my $height = ($ymax - $ymin + 2) / 2;
my $rooms = grep $_ eq '.', values %map;
my %rooms;
$rooms{$_} = $map{$_} for grep $map{$_} eq '.', keys %map;

print "Map nodes: $nodes, rooms: $rooms, width: $width, height: $height\n";

my $distance = 0;
$map{"0,0"} = $distance;
delete $rooms{"0,0"};
while () {
    my $count = 0;
    for my $position (keys %rooms) {
        my ($x, $y) = split ',', $position;

        if ($map{($x).','.($y-1)} && $map{($x).','.($y-2)} eq $distance ||
            $map{($x+1).','.($y)} && $map{($x+2).','.($y)} eq $distance ||
            $map{($x).','.($y+1)} && $map{($x).','.($y+2)} eq $distance ||
            $map{($x-1).','.($y)} && $map{($x-2).','.($y)} eq $distance) {
            $map{$position} = $distance + 1;
            delete $rooms{$position};
            $count++;
        }
    }
    last unless $count;
    $distance++;
}

print "Shortest distance to furthest room: ", max(values %map), "\n";

my $far_rooms = grep $_ >= 1000, values %map;
print "Rooms with distance 1000 or over: $far_rooms\n";

# draw();

sub draw {
    my $p = ' ';
    for my $y ($ymin-1..$ymax+1) {
        for my $x ($xmin-1..$xmax+1) {
            my $c = $map{"$x,$y"};
            print color('rgb222', 'on_rgb444'), ($c < 10 ? $p : ''), $c, $p if $c =~ /^\d+$/;
            print color('rgb222', 'on_rgb444'), $p, '•', $p if $c eq '.';
            print color('rgb222', 'on_rgb444'), $p, '-', $p if $c eq '-';
            print color('rgb222', 'on_rgb444'), $p, '|', $p if $c eq '|';
            print color('on_rgb222'), $p, ' ', $p if $c eq '';
        }
        print color('reset'), "\n";
    }
}
