#!/usr/bin/perl
use strict;


my %l;
my %d;
while (<>) {
    my ($f, $t, $d) = /(\w+) to (\w+) = (\d+)/ or die $_;
    $d{"$f-$t"} = 0+$d;
    $d{"$t-$f"} = 0+$d;
    $l{$f}++;
    $l{$t}++;
}

my @l = keys %l;
print "Locations: ", 0+@l, "\n";
print "Distances: ", 0+values %d, "\n";

my $m;
for my $l (@l) {
    print "Start location: $l\n";

    my @q = ([0, $l]);

    while (@q) {
        my $q = shift @q;
        my ($d, @v) = @$q;

        if (@v == @l) {
            print join(' -> ', @v), " = $d\n";
            $m = $d if $m < $d;
        }

        my %v = map {$_ => 1} @v;
        my $f = $v[-1];

        for my $t (grep !$v{$_}, @l) {
            push @q => [$d + $d{"$f-$t"}, @v, $t];
        }
    }
}

print "Maximum distance: $m\n";
