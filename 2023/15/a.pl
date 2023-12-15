#!/usr/bin/perl
use List::Util qw(sum);

print sum map{$s=0;for(split''){$s+=ord;$s*=17;$s%=256}$s}split/,|\n/,<>
