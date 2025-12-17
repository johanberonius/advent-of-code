#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my $x = 0;
my %c = map { $x++ => 0+$_ } <>;
my $c = 0;
my $i = 0;
my %s;
my @q = ([[], 0..$x-1]);
while (@q) {
    my ($d, @s) = @{shift @q};
    $i++;

    next if $s{join ',', sort { $a <=> $b } @$d}++;
    my $s = sum(map $c{$_}, @$d);
    if ($s == 150) {
        # print "@$d = $s\n";
        $c++;
        next;
    } elsif ($s > 150) {
        # print "@$d = $s\n";
        next;
    }

    push @q => [[@$d, $s[$_]], @s[0..$_-1, $_+1..$#s]] for 0..$#s;
}

print "Combinations: $c\n";
print "Iterations: $i\n";
