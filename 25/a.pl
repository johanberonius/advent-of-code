#!/usr/bin/perl
use strict;


my $cpk = 8987316;
my $dpk = 14681524;
# my $cpk = 5764801;
# my $dpk = 17807724;

my $mod = 20201227;

my $n = 1;
my $s = 7;
my $cls = 0;
while ($n != $cpk) {
    $cls++;
    $n *= $s;
    $n %= $mod;
}

print "Card loop size: $cls\n";

my $n = 1;
my $s = 7;
my $dls = 0;
while ($n != $dpk) {
    $dls++;
    $n *= $s;
    $n %= $mod;
}

print "Door loop size: $dls\n";

my $n = 1;
my $s = $dpk;
for (1..$cls) {
    $n *= $s;
    $n %= $mod;
}

print "Card encryption key: $n\n";

my $n = 1;
my $s = $cpk;
for (1..$dls) {
    $n *= $s;
    $n %= $mod;
}

print "Door encryption key: $n\n";
