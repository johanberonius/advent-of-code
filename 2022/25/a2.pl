#!/usr/bin/perl

%t=qw(= -2 - -1);%r=qw(-2 = -1 -);map{$i=0;$s[$i++]+=$t{$_}||$_ for reverse/./g}<>;for(@s){$j++;while($_>2){$_-=5;$s[$j]++}while($_<-2){$_+=5;$s[$j]--}}print map$r{$_}||$_,reverse@s