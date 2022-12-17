#!/usr/bin/perl
use strict;
use List::Util qw(min sum);

my @s;
my @p;

while (<>) {


    if (/^\$\s+cd\s+(\w+|\/)\s*$/) {

print "  " x @p;
print;
        push @s => 0;
        push @p => $#s;


    } elsif (/^\$\s+cd\s+\.\.\s*$/) {
print "  " x @p;
print;

        $s[$p[-2]] += $s[$p[-1]];
print "  " x @p;
print "add self size $s[$p[-1]] to parent size $s[$p[-2]]\n";
        pop @p;


    } elsif (/^(\d+)/) {
print "  " x @p;
print;
        $s[-1] += $1;

print "  " x @p;
print "size $s[-1]\n";

    }
}


while (@p>1) {
    $s[$p[-2]] += $s[$p[-1]];
print "  " x @p;
print "add self size $s[$p[-1]] to parent size $s[$p[-2]]\n";
    pop @p;
}



my $du = $s[0];

my $free = 70000000 - $du;
my $required = 30000000 - $free;

print "Used space: $du\n";
print "Free space: $free\n";
print "Required space: $required\n";

my $min = min grep $_&&$_>= $required, @s;
print "Size of smallest dir above required size: $min\n";
