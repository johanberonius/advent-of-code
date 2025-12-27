#!/usr/bin/perl
use strict;
use Digest::MD5 qw(md5_hex);

my $s = 'ngcjuoqr';
# my $s = 'abc';
my $c = 0;
my $n = 0;
my @md5;

l: while (1) {
    $md5[$c] ||= md5_hex("$s$c");
    if ($md5[$c] =~ /(\w)\1\1/) {
        my $t = $1;
        print "$c: $md5[$c] contains $t$t$t.\n";

        for my $i ($c+1 .. $c+1000) {
            $md5[$i] ||= md5_hex("$s$i");

            if ($md5[$i] =~ /$t{5}/) {
                $n++;
                print "$i: $md5[$i] contains $t$t$t$t$t, found $n keys.\n";
                if ($n == 64) {
                    print "Found key $n at $c\n";
                    last l;
                }
                last;
            }
        }
    }
    $c++;
}
