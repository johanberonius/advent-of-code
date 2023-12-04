#!/usr/bin/perl
use List::Util qw(sum);

print sum map{s/\d+//;my%w;$w{$_}++for/\d+/g;int 2**((grep$_>1,values%w)-1)}<>