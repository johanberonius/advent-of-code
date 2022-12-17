#!/usr/bin/perl
use strict;
use List::Util qw(sum min);
use List::MoreUtils qw(first_index);

my @a;
push @a => [/a=<(-?\d+),(-?\d+),(-?\d+)>/] while <>;
my @l = map { sqrt sum map $_ ** 2, @$_ } @a;
my $i = first_index {$_ == min @l} @l;

print "Index of particle with least accelleration: $i -> $l[$i]\n";
