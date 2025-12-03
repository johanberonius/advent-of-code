#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $sum = 0;
row: while (<>) {
    chomp;    
    print "$_: ";

    for my $n01 (reverse 1..9) {
        next unless /$n01/;
    for my $n02 (reverse 1..9) {
        next unless /$n01.*$n02/;
    for my $n03 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03/;
    for my $n04 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04/;
    for my $n05 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05/;
    for my $n06 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06/;
    for my $n07 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07/;
    for my $n08 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08/;
    for my $n09 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09/;
    for my $n10 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09.*$n10/;        
    for my $n11 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09.*$n10.*$n11/;        
    for my $n12 (reverse 1..9) {
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09.*$n10.*$n11.*$n12/;

        my $n = "$n01$n02$n03$n04$n05$n06$n07$n08$n09$n10$n11$n12";
        print "$n\n";
        $sum += $n;

        next row;        
    }}}}}}}}}}}}
}

print "Total output joltage: $sum\n";
