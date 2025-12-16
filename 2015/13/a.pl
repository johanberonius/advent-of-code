#!/usr/bin/perl
use strict;

my %h;
my %p;
while (<>) {
    my ($p1, $gl, $n, $p2) = /(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)./ or die $_;

    $gl = $gl eq 'gain' ? +1 : $gl eq 'lose' ? -1 : 0;

    $p{$p1}++;
    $p{$p2}++;
    $h{"$p1,$p2"} += $gl * $n;
    $h{"$p2,$p1"} += $gl * $n;
}

my @p = keys %p;

print "Persons: ", 0+@p, "\n";
print "Persons: @p\n";


my $i = 0;
my $m = 0;
for my $p (permutations(@p[1..$#p])) {
    $i++;
    unshift @$p => $p[0];
    my $h = 0;
    for my $i (0..$#p) {
        my $p1 = $p->[$i-1];
        my $p2 = $p->[$i];
        print "$p1 next to $p2: ", $h{"$p1,$p2"}, "\n";
        $h += $h{"$p1,$p2"};
    }

    print "Happiness: $h\n\n";
    $m = $h if $m < $h;
}

print "Maximum happiness: $m\n";
print "Iterations: $i\n";

sub permutations {
    my @a = @_;
    my $n = @a;
    my @r = ([@a]);
    my @c;
    my $i = 0;
    while ($i < $n) {
        if ($c[$i] < $i) {
            if ($i % 2) {
                ($a[$i], $a[$c[$i]]) = ($a[$c[$i]], $a[$i]);
            } else {
                ($a[$i], $a[0]) = ($a[0], $a[$i]);
            }
            push @r => [@a];
            $c[$i]++;
            $i = 0;
        } else {
            $c[$i] = 0;
            $i++;
        }
    }
    return @r;
}
