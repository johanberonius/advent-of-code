#!/usr/bin/perl
use strict;

chomp(my $t = <>);
print "Template: $t\n";

my %r;
while (<>) {
    $r{$1} = $2 if /(\w+)\s*->\s*(\w+)/;
}

my $re = join '|', map {
    my @c = split '';
    "$c[0](?=$c[1])";
} keys %r;

my $s = 0;
while (1) {
    $t =~ s/$re/$& . $r{$& . substr($',0,1)}/eg;

    $s++;
    print "After step $s: $t\n";
    last if $s >= 10;
}

my %c;
$c{$_}++ for split '', $t;
my @c = sort { $c{$a} <=> $c{$b} } keys %c;

print "Least common element: $c[0], $c{$c[0]}\n";
print "Most common element: $c[-1], $c{$c[-1]}\n";
print "Difference: ", $c{$c[-1]} - $c{$c[0]}, "\n";
