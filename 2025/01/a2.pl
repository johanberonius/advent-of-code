#!/usr/bin/perl

print 0+grep{tr/LR/-+/;($n+=$_)%100==50}<>
