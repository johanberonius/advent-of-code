#!/usr/bin/perl
use strict;

my $t = 0;
my $a = 0;
my $b = 0;
while (<>) {
    chomp;
    print;
    $t++;

    my $o = $_;
    my $i = $_;
    $o =~ s/\[.*?\]/ /g;
    $i =~ s/(^|\]).*?(\[|$)/ /g;

    print " \t $o";
    print " \t $i";

    while ($o =~ /([a-z])(?!\1)(?=([a-z])\1)/g) {
        print " \t found $1$2$1";
        $a++;
        my $bab = "$2$1$2";

        if ($i =~ /$bab/) {
            print " \t found [$bab]";
            $b++;
            last;
        } else {
            print " \t not found [$bab]";
        }
    }
    print "\n";
}

print "Total: $t\n";
print "ABA: $a\n";
print "BAB: $b\n";
