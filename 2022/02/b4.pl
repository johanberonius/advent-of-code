#!/usr/bin/perl
use List::Util qw(sum);

print sum map{/.$/;$j=-88+ord$&;(($j-65+ord)%3||3)+$j*3}<>