#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

# my $depth =  7305;
# my %target = (x => 13, y => 734);

my $depth =  510;
my %target = (x => 10, y=> 10);

my $total_risk = 0; # 114;
my $xmax = $target{x} + 10;
my $ymax = $target{y} + 10;


#            0: climbing
#              / \
#            /     \
#          /         \
#         0: rocky --- 1: wet
#        / \          / \
#      /     \      /     \
#    /         \  /         \
# 2: torch ----- 2: -------- 1: neither
#             narrow

my %geo;
my %erosion;
my %type;
my %map;
for my $y (0..$ymax) {
    for my $x (0..$xmax) {
        my $p = "$x,$y";
        if ($y == 0) {
            $geo{$p} = $x * 16807;
        } elsif ($x == 0) {
            $geo{$p} = $y * 48271;
        } elsif ($x == $target{x} && $y == $target{y}) {
            $geo{$p} = 0;
        } else {
            $geo{$p} = $erosion{($x-1).",$y"} * $erosion{"$x,".($y-1)};
        }

        $erosion{$p} = ($geo{$p} + $depth) % 20183;
        $type{$p} = $erosion{$p} % 3;
        $map{$p} = {0 => '.', 1 => '=', 2 => '|'}->{$type{$p}};
    }
}

for my $y (0..$target{y}) {
    for my $x (0..$target{x}) {
        $total_risk += $type{"$x,$y"};
    }
}

print "Total risk: $total_risk\n";

my $target_distance;
my %min_distance;
my @positions = ({x => 0, y => 0, tool => 2, distance => 0});
my %seen;
my $c;
my $d;
while (@positions) {
    my %p = %{shift @positions};

    unless ($seen{"$p{x},$p{y},$p{tool}"}) {
        my @moved = distance(\%p);
        for my $p (@moved) {
            $seen{"$p->{x},$p->{y},$p->{tool}"}++;

            my $type = $type{"$p->{x},$p->{y}"};

            if ($p->{tool} == $type) {
                $p->{tool} = ($p->{tool} - 1) % 3;
            } else {
                $p->{tool} = ($p->{tool} + 1) % 3;
            }

            $p->{distance} += 7;
            push @positions => $p;
        }
    }
    $c++;
}

draw();

print "Iterations: $c, $d\n";
print "Target distance: $target_distance\n";


sub distance {
    my $p = shift;
    my $tool = $p->{tool};
    my @positions = ($p);
    my %distance;
    my @moved;

    while (@positions) {
        my %p = %{shift @positions};
        my $pos = "$p{x},$p{y}";

        if (!exists($distance{$pos}) and
            exists $type{$pos} and
            ($type{$pos} == $tool or
             $type{$pos} == ($tool + 1) % 3)) {
            $distance{$pos} = $p{distance};
            $min_distance{$pos} = $distance{$pos} if !exists $min_distance{$pos} || $min_distance{$pos} > $distance{$pos};
            push @moved => \%p;

            last if ($p{x} == $target{x} && $p{y} == $target{y});
            last if $target_distance && $p{distance} >= $target_distance;
            # last if $p{distance} >= 1040;

            push @positions => (
                {x => $p{x}+1, y => $p{y},   tool => $tool, distance => $p{distance} + 1},
                {x => $p{x},   y => $p{y}+1, tool => $tool, distance => $p{distance} + 1},
                {x => $p{x}-1, y => $p{y},   tool => $tool, distance => $p{distance} + 1},
                {x => $p{x},   y => $p{y}-1, tool => $tool, distance => $p{distance} + 1},
            );
        }
        $d++;
    }

    my $distance = $distance{"$target{x},$target{y}"};
    if ($distance && $tool != 2) {
        $distance += 7;
    }
    if (!$target_distance || ($distance && $distance < $target_distance)) {
        $target_distance = $distance;
    }

    return @moved;
}

my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    my $p = ' ';
    for my $y (0..$ymax) {
        for my $x (0..$xmax) {
            my $t = $map{"$x,$y"};
            my $d = $min_distance{"$x,$y"};
            $d = sprintf '%3d', $d if exists $min_distance{"$x,$y"};
            print color('rgb111', 'on_rgb222'), $d || ($p, '•', $p) if $t eq '.';
            print color('rgb225', 'on_rgb114'), $d || ($p, '~', $p) if $t eq '=';
            print color('rgb210', 'on_rgb320'), $d || ($p, '|', $p) if $t eq '|';
        }
        print color('reset'), "\n";
        $lines++;
    }
    sleep 0.1;
}
