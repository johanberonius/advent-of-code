#!/usr/bin/perl
use strict;
use List::Util qw(max);

print "Highest boarding pass id: ", max(map { tr/FBLR/0101/; eval("0b$_") } <>), "\n";
