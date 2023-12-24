#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my %g;
my @b;
push @b => [/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/] while <>;

set($_ => 1) for @b;

while(1) {
    print "Move any bricks down…\n";
    last unless move();
}

print "\n";
print "All bricks settled.\n";
print "\n";

my %bg = %g;
my @bb = map [@$_], @b;

my $d;
my $s;
for my $b (@bb) {
    print "Disintegrate brick ($b->[0], $b->[1], $b->[2]) -> ($b->[3], $b->[4], $b->[5])\n";

    set($b => 0);
    my $m = move();
    $d++ unless $m;
    print "", ($m || "No"), " bricks moved.\n";

    while (1) {
        $s += $m;
        $m = move();
        print "", ($m || "No"), " bricks moved.\n";
        last unless $m;
    }

    %g = %bg;
    @b = map [@$_], @bb;
}

print "$d bricks could be disintegrated.\n";
print "$s other bricks would fall.\n";

sub move{
    my $m = 0;

    b: for my $b (sort { min($::a->[2], $::a->[5]) <=> min($::b->[2], $::b->[5])} @b) {
        my ($x1, $y1, $z1, $x2, $y2, $z2) = @$b;
        my $z = min($z1, $z2);
        my $f = $m + 1;

        while (1) {
            next b if $z == 1;
            $z--;
            for my $y (min($y1, $y2)..max($y1, $y2)) {
                for my $x (min($x1, $x2)..max($x1, $x2)) {
                    next b if $g{"$x,$y,$z"};
                }
            }
            set($b => 0);
            $b->[2]--;
            $b->[5]--;
            set($b => 1);
            print "Brick ($x1, $y1, $z1) -> ($x2, $y2, $z2) moved to ($b->[0], $b->[1], $b->[2]) -> ($b->[3], $b->[4], $b->[5])\n";
            $m = $f;
        }

    }

    return $m;
}

sub set{
    my $b = shift;
    my $v = shift;
    my ($x1, $y1, $z1, $x2, $y2, $z2) = @$b;

    for my $z (min($z1, $z2)..max($z1, $z2)) {
        for my $y (min($y1, $y2)..max($y1, $y2)) {
            for my $x (min($x1, $x2)..max($x1, $x2)) {
                $g{"$x,$y,$z"} = $v;
            }
        }
    }
}
