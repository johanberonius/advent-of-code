#!/usr/bin/perl
use strict;

my @p;
my $i = 0;

while (<>) {
    my $p = {i => $i++};
    push @p => $p;

    for my $t (qw(p v a)) {
        $p->{$t} = {};
        @{$p->{$t}}{qw(x y z)} = map 0+$_, /$t=<(-?\d+),(-?\d+),(-?\d+)>/;
    }

}

$_->{l} = sqrt($_->{x}**2 + $_->{y}**2 + $_->{z}**2) for map @{$_}{qw(p v a)}, @p;

@p = sort { $a->{a}{l} <=> $b->{a}{l} } @p;

my $c = 0;
while ($c < 40) {
    my %d;
    $d{"$_->{p}{x},$_->{p}{y},$_->{p}{z}"}++ for @p;
    @p = grep $d{"$_->{p}{x},$_->{p}{y},$_->{p}{z}"} <= 1, @p;

    for my $p (@p) {
        $p->{v}{$_} += $p->{a}{$_} for qw(x y z);
        $p->{p}{$_} += $p->{v}{$_} for qw(x y z);
        $_->{l} = sqrt($_->{x}**2 + $_->{y}**2 + $_->{z}**2) for @{$p}{qw(p v)};
    }
    $c++;
}

print scalar @p, " particles remaining after $c ticks.\n";
