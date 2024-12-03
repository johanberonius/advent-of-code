#!/usr/bin/perl

# $e=1;s/(do(n't)?)\(\)|mul\((\d+),(\d+)\)/$e=1if$1eq'do';$e=0if$2eq"n't";$s+=$e*$3*$4/eg for<>;print$s
# $e=1;s/(do(n't)?)\(\)|mul\((\d+),(\d+)\)/$e=$2ne"n't"if$1;$s+=$e*$3*$4/eg for<>;print$s
# s/(do(n't)?)\(\)|mul\((\d+),(\d+)\)/$e=$2eq"n't"if$1;$s+=!$e*$3*$4/eg for<>;print$s
s/(do(n't)?)\(\)|mul\((\d+),(\d+)\)/$e=$2if$1;$s+=!$e*$3*$4/eg for<>;print$s
