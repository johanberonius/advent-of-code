#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $sum = 0;
my $row = 0;
my $c = 0;
row: while (<>) {
    $row++;
    chomp;
    print "$row, $_: ";

    for my $n01 (reverse 1..9) {
        $c++;
        next unless /$n01.{11}/;
    for my $n02 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.{10}/;
    for my $n03 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.{9}/;
    for my $n04 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.{8}/;
    for my $n05 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.{7}/;
    for my $n06 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.{6}/;
    for my $n07 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.{5}/;
    for my $n08 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.{4}/;
    for my $n09 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09.{3}/;
    for my $n10 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09.*$n10.{2}/;
    for my $n11 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09.*$n10.*$n11.{1}/;
    for my $n12 (reverse 1..9) {
        $c++;
        next unless /$n01.*$n02.*$n03.*$n04.*$n05.*$n06.*$n07.*$n08.*$n09.*$n10.*$n11.*$n12/;

        my $n = "$n01$n02$n03$n04$n05$n06$n07$n08$n09$n10$n11$n12";
        print "$n\n";
        $sum += $n;

        next row;
    }}}}}}}}}}}}
}

print "Total output joltage: $sum, iterations: $c\n";
