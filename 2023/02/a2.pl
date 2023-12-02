#!/usr/bin/perl
use List::Util qw(sum max);

print sum map{max(/\d+ r/g)<13&max(/\d+ g/g)<14&max(/\d+ b/g)<15&&/(\d+)/}<>