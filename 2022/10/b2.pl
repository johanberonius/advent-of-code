#!/usr/bin/perl

sub d{print abs$x+1-$c%40<=1?'#':'.',++$c%40?'':"\n"}map{d;$x+=d&&$&if/-?\d+/}<>