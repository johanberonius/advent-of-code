#!/usr/bin/perl
use strict;
use Term::ANSIColor;
use Time::HiRes qw(sleep);

my $depth =  7305;
my %target = (x => 13, y => 734, z => 2);
my $max_distance = 1040;

# my $depth =  510;
# my %target = (x => 10, y=> 10, z => 2);
# my $max_distance = 48;

my $total_risk = 0; # 114;
my $target_pos = "$target{x},$target{y},$target{z}";
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

my %distance;
my @positions = ({x => 0, y => 0, tool => 2, distance => 0});
my $c;

while (@positions) {
    my %p = %{shift @positions};
    my $tool = $p{tool};
    my $pos = "$p{x},$p{y}";
    my $dpos = "$p{x},$p{y},$p{tool}";

    if ((!exists($distance{$dpos}) or $distance{$dpos} > $p{distance}) and
        exists $type{$pos} and
        ($type{$pos} == $tool or
            $type{$pos} == ($tool + 1) % 3)) {
        $distance{$dpos} = $p{distance};

        if (!($distance{$target_pos} && $p{distance} >= $distance{$target_pos}) and
            $p{distance} < $max_distance) {
            push @positions => (
                {x => $p{x}+1, y => $p{y},   tool => $tool, distance => $p{distance} + 1},
                {x => $p{x},   y => $p{y}+1, tool => $tool, distance => $p{distance} + 1},

                {x => $p{x}-1, y => $p{y},   tool => $tool, distance => $p{distance} + 1},
                {x => $p{x},   y => $p{y}-1, tool => $tool, distance => $p{distance} + 1},

                {x => $p{x},   y => $p{y},   tool => ($tool - 1) % 3, distance => $p{distance} + 7},
                {x => $p{x},   y => $p{y},   tool => ($tool + 1) % 3, distance => $p{distance} + 7},
            );

            @positions = sort { $a->{distance} <=> $b->{distance} } @positions;
        }
    }
    $c++;
    unless ($c % 10_000) {
        print "$c, q: ", 0+@positions, ", $distance{$target_pos}\n";
    }
}

# draw();

print "Iterations: $c\n";
print "Target distance: $distance{$target_pos}\n";


my $lines;
sub draw {
    print "\x1B[", $lines, "A" if $lines;
    $lines = 0;
    my $p = ' ';
    for my $y (0..$ymax) {
        for my $x (0..$xmax) {
            my $t = $map{"$x,$y"};
            my $d = $distance{"$x,$y,2"};
            $d = sprintf '%3d', $d if exists $distance{"$x,$y,2"};
            print color('rgb111', 'on_rgb222'), $d || ($p, '•', $p) if $t eq '.';
            print color('rgb225', 'on_rgb114'), $d || ($p, '~', $p) if $t eq '=';
            print color('rgb210', 'on_rgb320'), $d || ($p, '|', $p) if $t eq '|';
        }
        print color('reset'), "\n";
        $lines++;
    }
    sleep 0.1;
}
