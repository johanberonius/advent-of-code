#!/usr/bin/perl
use strict;

my @i = split '', 99_999_999_999_999;
my ($w, $z);

$w = shift @i;
if ($z % 26 + 13 != $w) {
    $z = $z * 26 + $w + 14;
}

$w = shift @i;
if ($z % 26 + 12 != $w) {
    $z = $z * 26 + $w + 8;
}

$w = shift @i;
if ($z % 26 + 11 != $w) {
    $z = $z * 26 + $w + 5;
}

$z = int($z / 26);
$w = shift @i;
if ($z % 26 != $w) {
    $z = $z * 26 + $w + 4;
}

$w = shift @i;
if ($z % 26 + 15 != $w) {
    $z = $z * 26 + $w + 10;
}

$z = int($z / 26);
$w = shift @i;
if ($z % 26 - 13 != $w) {
    $z = $z * 26 + $w + 13;
}

$w = shift @i;
if ($z % 26 + 10 != $w) {
    $z = $z * 26 + $w + 16;
}

$z = int($z / 26);
$w = shift @i;
if ($z % 26 - 9 != $w) {
    $z = $z * 26 + $w + 5;
}

$w = shift @i;
if ($z % 26 + 11 != $w) {
    $z = $z * 26 + $w + 6;
}

$w = shift @i;
if ($z % 26 + 13 != $w) {
    $z = $z * 26 + $w + 13;
}

$z = int($z / 26);
$w = shift @i;
if ($z % 26 - 14 != $w) {
    $z = $z * 26 + $w + 6;
}

$z = int($z / 26);
$w = shift @i;
if ($z % 26 - 3 != $w) {
    $z = $z * 26 + $w + 7;
}

$z = int($z / 26);
$w = shift @i;
if ($z % 26 - 2 != $w) {
    $z = $z * 26 + $w + 13;
}

$z = int($z / 26);
$w = shift @i;
if ($z % 26 - 14 != $w) {
    $z = $z * 26 + $w + 3;
}

my $valid = !$z;
