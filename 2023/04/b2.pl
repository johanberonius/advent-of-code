#!/usr/bin/perl
use List::Util qw(sum);

print sum map{s/\d+//;my%w;$w{$_}++for/\d+/g;$c=1+shift@c;$c[$_]+=$c for 0..(grep$_>1,values%w)-1;$c}<>