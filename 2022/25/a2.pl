#!/usr/bin/perl

%t=qw(= -2 - -1);%r=qw(-2 = -1 -);map{$i=0;$s[$i++]+=$t{$_}||$_ for reverse/./g}<>;for(@s){$_+=$m;$m=0;++$m&&($_-=5)while$_>2;--$m&&($_+=5)while$_<-2}print map$r{$_}||$_,reverse@s