#!/usr/bin/perl
use strict;

my $p = 'vzbxxyzz';
my $n = 0;
for ($p .. 'zzzzzzzz') {
    next unless /abc|bcd|cde|def|efg|fgh|ghi|hij|jik|ikl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz/;
    next if /[iol]/;
    next unless /(\w)\1.*(\w)\2/;
    print "$_\n";
    last if $n++;
}
