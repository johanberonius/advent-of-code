#!/usr/bin/perl

s/mul\((\d+),(\d+)\)/$s+=$1*$2/eg for<>;print$s