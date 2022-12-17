#!/usr/bin/perl
use strict;
use List::Util qw(sum max);

my $i = 0;
my $j = 0;
my @s;
my @p;
while (<>) {
    push @p => [map 0+$_, split '/'];
}

t([], [@p]);

sub t {
    my $c = shift;
    my $p = shift;
    my $e = @$c ? $$c[-1][-1] : 0;
    my @n;
    my @l;
    $i++;

    for my $p (@$p) {
        if ($p->[0] == $e) {
            push @n => [$p->[0], $p->[1]];
        } elsif ($p->[1] == $e) {
            push @n => [$p->[1], $p->[0]];
        } else {
            push @l => $p;
        }
    }

    for (0..$#n) {
        t([@$c, $n[$_]], [@l,@n[0..$_-1,$_+1..$#n]]);
    }

    unless (@n) {
        push @s => [0+@$c, 0+sum(map {@$_} @$c)];
        $j++;
    }
}

print "Found $j possible assemblies, max strength: ", max(map $_->[1], @s), ".\n";
my $s = (sort { $b->[0] <=> $a->[0] or $b->[1] <=> $a->[1] } @s)[0];
print "Longest assembly: $s->[0], with max strength: $s->[1].\n";
