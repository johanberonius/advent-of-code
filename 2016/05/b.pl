#!/usr/bin/perl
use strict;
use Digest::MD5 qw(md5_hex);

my $s = 'cxdnnyjw';
# my $s = 'abc';
my $c = 0;
my $p = ' ' x 8;
while (1) {
    my $h = md5_hex("$s$c");
    if (substr($h, 0, 5) eq '00000') {
        my $i = substr $h, 5, 1;
        print "$h, $i";
        if ($i ge '0' && $i le '7') {
            my $c = substr $h, 6, 1;
            my $d = substr $p, $i, 1;
            print ", $c, $d";
            substr $p, $i, 1, $c if $d eq ' ';
            print ", $p";
            last if index($p, ' ') == -1;
        }
        print "\n";
    }
    $c++;
}
print "\nPassword: $p\n";
