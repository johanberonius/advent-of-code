#!/usr/bin/perl
use List::Util qw(sum);

%v=(one,1,two,2,three,3,four,4,five,5,six,6,seven,7,eight,8,nine,9);$r=join'|',keys%v;
print sum map{0 while s/$r/$v{$&}.substr$&,1/eg;@n=grep$_+0,split'';"$n[0]$n[-1]"}<>
