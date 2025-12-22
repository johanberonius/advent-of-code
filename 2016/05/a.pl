#!/usr/bin/perl
use strict;
use Digest::MD5 qw(md5_hex);

my $s = 'cxdnnyjw';
# my $s = 'abc';
my $c = 0;
my $p = '';
while (1) {
    my $h = md5_hex("$s$c");
    $p .= substr($h, 5, 1) if substr($h, 0, 5) eq '00000';
    last if length $p == 8;
    $c++;
}
print "Password: $p\n";
