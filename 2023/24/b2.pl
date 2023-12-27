#!/usr/bin/perl
use strict;
use List::Util qw(shuffle);

my @p;
while (<>) {
    my $n = '\s*(-?\d+)';
    push @p => [[$1, $2, $3], [$4, $5, $6]] if /$n,$n,$n\s*\@$n,$n,$n/;
}

@p = shuffle @p;

my ($h0, $v0) = @{$p[0]};
my ($h1, $v1) = @{$p[1]};
my ($h2, $v2) = @{$p[2]};
my ($h3, $v3) = @{$p[3]};

print "Hailstone 1: @$h0 @ @$v0\n";
print "Hailstone 2: @$h1 @ @$v1\n";
print "Hailstone 3: @$h2 @ @$v2\n";
print "Hailstone 4: @$h3 @ @$v3\n";

print "Translate relative to hailstone 1.\n";

$h1 = subtract($h1, $h0);
$v1 = subtract($v1, $v0);

$h2 = subtract($h2, $h0);
$v2 = subtract($v2, $v0);

$h3 = subtract($h3, $h0);
$v3 = subtract($v3, $v0);

print "Hailstone 2: @$h1 @ @$v1\n";
print "Hailstone 3: @$h2 @ @$v2\n";
print "Hailstone 4: @$h3 @ @$v3\n";

# A point and two verctors defines a plane
my $p0 = $h1;
my $p1 = $v1;
my $p2 = subtract([0, 0, 0], $h1);
my $p1x2 = cross($p1, $p2);
print "Hailstone 2 plane: @$p0 -> @$p1 -> @$p2\n";
print "Hailstone 2 plane cross: @$p1x2\n";

# A point and a vector defines a line for hailstone 3.
my $l0 = $h2;
my $l1 = $v2;
print "Hailstone 3 line: @$l0 -> @$l1\n";

# Find time and location of intersection of hailstone 3 with plane.
my $t0 = dot($p1x2, subtract($l0, $p0)) / dot(subtract([0, 0, 0], $l1), $p1x2);
my $s0 = add($l0, mul($l1, $t0));
print "Hailstone 3 line intersects plane at: @$s0 after $t0\n";

# A point and a vector defines a line for hailstone 4.
my $l0 = $h3;
my $l1 = $v3;
print "Hailstone 4 line: @$l0 -> @$l1\n";

# Find time and location of intersection of hailstone 4 with plane.
my $t1 = dot($p1x2, subtract($l0, $p0)) / dot(subtract([0, 0, 0], $l1), $p1x2);
my $s1 = add($l0, mul($l1, $t1));
print "Hailstone 4 line intersects plane at: @$s1 after $t1\n";

# From the two intersection points, find stones initial position and velocity.
my $td = $t1 - $t0;
print "Time between intersections: $td\n";

my $sd = subtract($s1, $s0);
print "Distance between intersections: @$sd\n";

my $sv = div($sd, $td);
my $sp = add($s0, mul($sv, -$t0));
print "Stone: @$sp @ @$sv\n";

# Translate back to original frame of reference by adding position and velocity from hailstone 1.
$sp = add($sp, $h0);
$sv = add($sv, $v0);
print "Translate back.\n";

print "Stone: @$sp @ @$sv\n";
print "Sum: ", ($sp->[0] + $sp->[1] + $sp->[2]),"\n";

sub cross{
    my $a = shift;
    my $b = shift;
    [
        $a->[1] * $b->[2] - $a->[2] * $b->[1],
        $a->[2] * $b->[0] - $a->[0] * $b->[2],
        $a->[0] * $b->[1] - $a->[1] * $b->[0]
    ];
}

sub dot{
    my $a = shift;
    my $b = shift;
    $a->[0] * $b->[0] + $a->[1] * $b->[1] + $a->[2] * $b->[2];
}

sub subtract{
    my $a = shift;
    my $b = shift;
    [$a->[0] - $b->[0], $a->[1] - $b->[1], $a->[2] - $b->[2]];
}

sub add{
    my $a = shift;
    my $b = shift;
    [$a->[0] + $b->[0], $a->[1] + $b->[1], $a->[2] + $b->[2]];
}

sub mul{
    my $a = shift;
    my $b = shift;
    [$a->[0] * $b, $a->[1] * $b, $a->[2] * $b];
}

sub div{
    my $a = shift;
    my $b = shift;
    [$a->[0] / $b, $a->[1] / $b, $a->[2] / $b];
}
