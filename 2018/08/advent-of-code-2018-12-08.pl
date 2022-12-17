#!/usr/bin/perl
use strict;

$/ = ' ';

my ($c, $n);
my $b = b();

print "$c branches\n";
print "Sum of metadata: $n\n";

sub b {
    my $b = {};
    my $s = 0+<>;
    my $m = 0+<>;
    $c++;

    print "Branch with $s children and $m metadata\n";

    push @{$b->{s}} => b() for 1..$s;
    push @{$b->{m}} => $n += 0+<> for 1..$m;
    return $b;
}
