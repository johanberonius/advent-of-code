#!/usr/bin/perl
use strict;

my %r = (
    kth => 'z12',
    z12 => 'kth',

    gsd => 'z26',
    z26 => 'gsd',

    z32 => 'tbt',
    tbt => 'z32',

    qnf => 'vpm',
    vpm => 'qnf',
);

while (<>) {
    s/(?<= -> )(\w+)/$r{$1} || $1/e;
    print;
}
