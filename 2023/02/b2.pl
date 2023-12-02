#!/usr/bin/perl
use List::Util qw(sum max);

print sum map{max(/\d+ r/g)*max(/\d+ g/g)*max(/\d+ b/g)}<>