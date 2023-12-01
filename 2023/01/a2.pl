#!/usr/bin/perl
use List::Util qw(sum);

print sum map{@n=grep$_+0,split'';"$n[0]$n[-1]"}<>