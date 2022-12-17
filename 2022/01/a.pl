#!/usr/bin/perl
use strict;
use List::Util qw(max sum);

$/ = "\n\n";
print max map sum(split),<>;
