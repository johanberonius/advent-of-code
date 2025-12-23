#!/usr/bin/perl
use strict;

my $t = 0;
my $a = 0;
my $c = 0;
my $i = 0;
while (<>) {
    chomp;
    print;
    $t++;

    if (/(.)(?!\1)(.)\2\1/) {
        print " \t found $1$2$2$1";
        $a++;

        if (/\[[^\[\]]*?(.)(?!\1)(.)\2\1[^\[\]]*?\]/) {
            print " \t found [$1$2$2$1]";
            $i++;
        } else {
            print " TLS";
            $c++;
        }
    }
    print "\n";
}

print "Total: $t\n";
print "abba: $a\n";
print "Within []: $i\n";
print "Count: $c\n";
