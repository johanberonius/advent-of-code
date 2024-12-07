#!/usr/bin/perl

map{($s,$n,@n)=split'\D+';@c=$n;for$n(@n){@c=map{$_+$n,$_*$n,"$_$n"}@c}$c+=$s if grep$_==$s,@c}<>;print$c