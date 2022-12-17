#!/usr/bin/perl
use List::Util qw(min);

map{do{push@s,0;push@p,$#s}if/d [^.]/;do{$s[$p[-2]]+=$s[$p[-1]];pop@p}if/d \./&&@p>1;$s[-1]+=$&if/^\d+/}<>,('d .')x9;print min grep$_>=$s[0]-4e7,@s
