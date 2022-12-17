#!/usr/bin/perl
use strict;
use List::Util qw(sum);

$/ = ' ';

my $c;
my $b = b();

print "$c branches\n";
print "Root value: ", v($b), "\n";

sub b {
    my $b = {};
    my $s = 0+<>;
    my $m = 0+<>;
    $c++;

    print "Branch with $s children and $m metadata\n";

    push @{$b->{s}} => b() for 1..$s;
    push @{$b->{m}} => 0+<> for 1..$m;
    return $b;
}

sub v {
    my $b = shift;
    return sum @{$b->{m}} unless $b->{s};
    return sum map v($b->{s}[$_-1]), grep $_ > 0, @{$b->{m}};
}
