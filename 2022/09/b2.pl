#!/usr/bin/perl
use Math::Utils qw(sign);

%d=(U,[0,-1],R,[1],D,[0,1],L,[-1]);map{/(\w) (\d+)/;for(1..$2){$t[0]{x}+=$d{$1}[0];$t[0]{y}+=$d{$1}[1];for(1..9){$x=$t[$_]{x}-$t[$_-1]{x};$y=$t[$_]{y}-$t[$_-1]{y};if(abs$x>1||abs$y>1){$t[$_]{x}-=sign$x;$t[$_]{y}-=sign$y}}$t{"$t[9]{x},$t[9]{y}"}++}}<>;print 0+keys%t