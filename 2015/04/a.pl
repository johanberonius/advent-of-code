#!/usr/bin/perl
use strict;
use Digest::MD5 qw(md5_hex);

my $c = 0;
while (1) {
    my $h = md5_hex("ckczppom$c");
    last if substr($h, 0, 6) eq '000000';
    $c++;
}
print "$c\n";
