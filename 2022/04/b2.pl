#!/usr/bin/perl
# use strict;
use List::Util qw(min max product sum);

#print sum map{/(\d+)-(\d+),(\d+)-(\d+)/;$2>=$3&&$1<=$4}<>
#print sum map{@a=split/\D/;$a[1]>=$a[2]&&$a[0]<=$a[3]}<>
#print sum map{($a,$b,$c,$d)=split/\D/;$b>=$c&&$a<=$d}<>
print sum map{@a=/\d+/g;$a[1]>=$a[2]&&$a[0]<=$a[3]}<>
