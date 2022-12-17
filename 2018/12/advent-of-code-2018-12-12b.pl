#!/usr/bin/perl
use strict;
use List::Util qw(min max sum);

my %i;
my $i = 0;
$i{$i++} = $_ eq '#' for map { split '' } <> =~ /state:\s+([.#]+)/;

print "$i pots\n";

my @r;
while (<>) {
    /([.#]{5})\s+=>\s+([.#])/ or next;
    push @r => $2 eq '#';
}

print 0+@r, " rules\n";

# use Data::Dumper;
# print Dumper(\@r);
use Time::HiRes qw(time);
my $t1 = time;

my $g = 0;
while () {
    my $min = min(keys %i);
    my $max = max(keys %i);

    # my @s = @i{$min..$max};
    # print "$g: [$min..$max] ", @s, "\n";

    unless ($g % 10_000) {
        my $t2 = time - $t1;

        my $range = $max - $min;

        print "$g, range: $min-$max: $range, time for 50G: ", ($t2/$g * 50_000_000_000 / 3600), " hours \n" if $g;
print "$g generations\n";

my $s = sum keys %i;
print "Number of plants: ", 0+(keys %i), "\n";
print "Positions: ", join(', ', sort { $a <=> $b } keys %i), "\n";
print "Sum of positions: $s\n";
print "\n";

    }

    last if $g >= 100_000;

    my $r = $i{$min-4};
    $r <<= 1;
    $r |= $i{$min-3};
    $r <<= 1;
    $r |= $i{$min-2};
    $r <<= 1;
    $r |= $i{$min-1};

    for $i ($min-2..$max+2) {
        $r <<= 1;
        $r &= 0b11110;
        $r |= $i{$i+2};
        $i{$i} = $r[$r] or delete $i{$i};
    }

    $g++;
}

# print "$g generations\n";

# my $s = sum keys %i;
# print "Positions: ", join(', ', sort { $a <=> $b } keys %i), "\n";
# print "Sum of positions: $s\n";
