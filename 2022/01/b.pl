#!/usr/bin/perl
use strict;
use List::Util qw(max sum);

$/ = "\n\n";
print sum@{[sort{$b<=>$a}map sum(split),<>]}[0..2];
