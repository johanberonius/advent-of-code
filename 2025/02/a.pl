#!/usr/bin/perl
use strict;

my @id = map [split '-'], split ',', <>;
my $sum = 0;

for (@id) {
    my ($min, $max) = @$_;    
    print "$min-$max invalid IDs: ";

    for ($min .. $max) {
        if (/^(\d+)\1$/) {            
            $sum += $_;
            print "$_, ";
        }
    }
    print "\n";
}

print "Sum of invalid IDs: $sum\n";
