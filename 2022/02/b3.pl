#!/usr/bin/perl
use List::Util qw(sum);

print sum map{$i=-65+ord;$j=-88+ord substr$_,2;(($i+$j)%3||3)+$j*3}<>