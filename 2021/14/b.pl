#!/usr/bin/perl
use strict;

use Time::HiRes qw(time);
my $t1 = time();


chomp(my $t = <>);
my @t = split '', $t;
print "Template: @t\n";

my %r;
while (<>) {
    $r{$1} = $2 if /(\w+)\s*->\s*(\w+)/;
}

my %e;
for my $i (0..@t-2) {
    $e{$t[$i]}++;
    my $e = r($t[$i], $t[$i+1], 40);
    $e{$_} += $e->{$_} for keys %$e;
}
$e{$t[-1]}++;

my @e = sort { $e{$a} <=> $e{$b} } keys %e;
print map "$_: $e{$_}\n", @e;

print "Least common element: $e[0], $e{$e[0]}\n";
print "Most common element: $e[-1], $e{$e[-1]}\n";
print "Difference: ", $e{$e[-1]} - $e{$e[0]}, "\n";

print "Time: ", time() - $t1, "\n";

my %c;
sub r {
    my ($a, $b, $l) = @_;
    return $c{"$a,$b,$l"} if $c{"$a,$b,$l"};
    my $m = $r{"$a$b"};
    my $c = {};
    if ($l > 0 && $m) {
        $c->{$m}++;

        my $d = r($a, $m, $l-1);
        $c->{$_} += $d->{$_} for keys %$d;

        $d = r($m, $b, $l-1);
        $c->{$_} += $d->{$_} for keys %$d;
    }

    return $c{"$a,$b,$l"} = $c;
}
