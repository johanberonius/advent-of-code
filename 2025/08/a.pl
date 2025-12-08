#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @b;
while (<>) {
    my ($x, $y, $z) = /(\d+)/g;
    push @b => {x => $x, y => $y, z => $z};
}

print "Boxes: ", 0+@b, "\n";

my @d;
my %d;
for my $b1 (@b) {
    for my $b2 (@b) {
        next if $b1 == $b2;
        next if $d{"$b1,$b2"}++;
        next if $d{"$b2,$b1"}++;

        my $dx = abs($b2->{x} - $b1->{x});
        my $dy = abs($b2->{y} - $b1->{y});
        my $dz = abs($b2->{z} - $b1->{z});

        my $d = sqrt($dx * $dx + $dy * $dy + $dz * $dz);

        push @d => {d => $d, b1 => $b1, b2 => $b2};
    }
}

print "Distances: ", 0+@d, "\n";

@d = sort { $a->{d} <=> $b->{d} } @d;

my $i = 0;
my $j = 0;
my $c = 0;
my %c;
for my $d (@d[0..999]) {
    # print "Distance $d->{d} from $d->{b1}{x},$d->{b1}{y},$d->{b1}{z} to $d->{b2}{x},$d->{b2}{y},$d->{b2}{z}\n";
    $j++;

    my $c1 = $d->{b1}{c};
    my $c2 = $d->{b2}{c};
    next if $c1 && $c2 && $c1 == $c2;
    $i++;
    my $ci = $c1 || $c2 || ++$c;

    my $cc1 = $c{$c1} || 1;
    my $cc2 = $c{$c2} || 1;
    delete $c{$c1};
    delete $c{$c2};

    $c{$ci} = $cc1 + $cc2;
    $d->{b1}{c} = $d->{b2}{c} = $ci;
    for my $b (@b) {
        $b->{c} = $ci if $c1 && $b->{c} == $c1;
        $b->{c} = $ci if $c2 && $b->{c} == $c2;
    }
}

print "Made $i connections of $j pairs.\n";

my @c = sort { $b <=> $a } values %c;
print "Product of three largest curcuits: ", $c[0]*$c[1]*$c[2], "\n";

print "In any cluster: ", sum(values %c), "\n";
