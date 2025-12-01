#!/usr/bin/perl

print 0+grep{tr/LR/-+/;($n=eval"$n$_")%100==50}<>
