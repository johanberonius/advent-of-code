#!/usr/bin/perl
use strict;

my @p = 0..15;
my @i = @p;
my @j = @p;
my @d = 'a'..'p';
my @e = @d;
my %l; @l{@d} = @d;
my $c = 0;
my $i = 1_000;
my $x = 3;
my $j;

$/ = ',';
while (<>) {
    chomp;
    my ($i, $a, $b) = /([a-z])([a-z0-9]+)\/?([a-z0-9]*)/;
    $c++;

    if ($i eq 's') {
        unshift @p => splice @p, -$a;
    } elsif ($i eq 'x') {
        @p[$a,$b] = @p[$b,$a];
    } elsif ($i eq 'p') {
        @l{$a,$b} = @l{$b,$a};
    }
}

%l = map { $l{$_} => $_ } keys %l;

print "Number of intructions: $c\n";
print "Running $i^$x iterations.\n";
print "Transformation of positions: @p\n";

for (1..$x) {
    $j = $i;
    @i = @i[@p] while $j--;
    @p = @i;
    @i = @j;
    print "Transformation of positions after $i^$_ iterations: @p\n";
}

print "Transformed positions: @p\n";

print "Transformation of letters: @l{sort keys %l}\n";

for (1..$x) {
    $j = $i;
    @d = @l{@d} while $j--;
    @l{@e} = @d;
    @d = @e;
    print "Transformation of letters after $i^$_ iterations: @l{sort keys %l}\n";
}

@d = @l{@e[@i]};

print "Transformation of letters done.\n";
print "Final order: ", @d, "\n";
