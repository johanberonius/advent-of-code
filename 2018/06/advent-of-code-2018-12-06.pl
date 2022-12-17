#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my (@c, %g);

while (<>) {
    push @c => [map 0+$_, split /,\s+/];
}

my $xmin = min map $_->[0], @c;
my $xmax = max map $_->[0], @c;
my $ymin = min map $_->[1], @c;
my $ymax = max map $_->[1], @c;
my $w = $xmax - $xmin + 1;
my $h = $ymax - $ymin + 1;
my $a2 = $w * $h;

print 0+@c, " coordinates, grid ${xmin}x$ymin -> ${xmax}x$ymax, width: $w, height: $h, area $a2\n";


for my $y ($ymin..$ymax) {
    for my $x ($xmin..$xmax) {
        my %d = map { $_ => abs($c[$_][0] - $x) + abs($c[$_][1] - $y) } 0..$#c;
        my @d = sort { $d{$a} <=> $d{$b} } keys %d;
        $g{"$x,$y"} = $d[0] if $d{$d[0]} < $d{$d[1]};
    }
}

my %e;
for my $y ($ymin..$ymax) {
    for my $x ($xmin..$xmax) {
        next unless $x == $xmin || $x == $xmax || $y == $ymin || $y == $ymax;
        $e{$g{"$x,$y"}}++;
    }
}

my %f;
$f{$_}++ for grep !$e{$_}, values %g;
my ($m) = sort { $b <=> $a } values %f;

print "Largest area: $m\n";

for my $y ($ymin..$ymax) {
    for my $x ($xmin..$xmax) {
        my $c = $g{"$x,$y"};
        my $l = exists $g{"$x,$y"} ? ('a'..'z','a'..'z')[$c] : '.';
        $l = uc $l if $c[$c][0] == $x && $c[$c][1] == $y;
        print $l;
    }
    print "\n";
}
