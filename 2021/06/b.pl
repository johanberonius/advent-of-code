#!/usr/bin/perl
use strict;

my @n = map 0+$_, split ',', <>;

print "Number of lanternfish: ", 0+@n, "\n";
print "Initial state: @n\n";

my @i = (0) x 9;
$i[$_]++ for @n;

print "Increase in days: @i\n";

my $d = 0;
my $c = @n;

do {
    my $i = shift @i;
    $i[8] += $i;
    $i[6] += $i;
    $c += $i;
    $d++;
    # print "Increase in days: @i\n";

} until ($d >= 256);

print "Number of lanternfish after $d days: $c\n";
