#!/usr/bin/perl
use strict;
use List::Util qw(sum max);

my @p;
while (<>) {
    push @p => [map 0+$_, split '/'];
}

# use Data::Dumper;
# print Dumper(\@p);

my $i = 0;
my $j = 0;
my @m;

t([], [@p]);

sub t {
    my $c = shift;
    my $p = shift;
    my $e = @$c ? $$c[-1][-1] : 0;

    $i++;
# return if $i > 3;
# print "Iteration: $i\n";
# print "Assembled parts:", join('--', map "$_->[0]/$_->[1]", @$c), "\n";
# print "Finding parts matching end: $e\n";
# print "Available part: $_->[0]/$_->[1]\n" for @$p;

    my @n;
    my @l;
    for my $p (@$p) {
        if ($p->[0] == $e) {
            push @n => [$p->[0], $p->[1]];
        } elsif ($p->[1] == $e) {
            push @n => [$p->[1], $p->[0]];
        } else {
            push @l => $p;
        }
    }

# print "Matching part: $_->[0]/$_->[1]\n" for @n;
# print "Remaining part: $_->[0]/$_->[1]\n" for @l;

    for (0..$#n) {
        t([@$c, $n[$_]], [@l,@n[0..$_-1,$_+1..$#n]]);
    }

    unless (@n) {
# print "No matching parts, result: ";
        push @m => sum(map {@$_} @$c);
        # print join('--', map "$_->[0]/$_->[1]", @$c), " = ", $m[-1], "\n";
        $j++;
    }
}

print "Found $j possible assemblies, max score: ", max(@m), ".\n";

# 0/1
# 0/1--10/1
# 0/1--10/1--9/10 = 31
# 0/2
# 0/2--2/3
# 0/2--2/3--3/4
# 0/2--2/3--3/5
# 0/2--2/2
# 0/2--2/2--2/3
# 0/2--2/2--2/3--3/4
# 0/2--2/2--2/3--3/5
