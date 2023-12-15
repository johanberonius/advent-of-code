#!/usr/bin/perl
use strict;
use List::Util qw(sum max);

my @s = split /,|\n/, <>;
my @b;
my @o;
for (@s) {
    my ($l, $o, $n) = /(\w+)([-=])(\d+)?/ or die;
    my $h=0;
    for (split '', $l) {
        $h += ord;
        $h *= 17;
        $h %= 256;
    }

    if ($o eq '=') {
        $o[$h]{$l} ||= 1 + max values %{$o[$h]};
        $b[$h]{$l} = $n;

    } elsif ($o eq '-') {
        delete $o[$h]{$l};
        delete $b[$h]{$l};
    } else {
        die;
    }

}

my $s = 0;
for my $i (0..@b-1) {
    my $b = $b[$i];
    my $o = $o[$i];
    my $j = 0;

    for my $k (sort { $o->{$::a} <=> $o->{$::b} } keys %$b) {
        my $v = ($i+1) * ($j+1) * $b->{$k};
        print "Box ", ($i+1), " order $o->{$k} slot ", ($j+1), " label $k focal $b->{$k} value $v\n";
        $s += $v;
        $j++;
    }
}

print "Sum: $s\n";
