#!/usr/bin/perl
use strict;

my %d;
while (<>) {
    chomp;
    my ($d, @o) = split /:?\s+/;
    $d{$d} = \@o;
}

my %p = ();
my $s = 'svr';
my $e = 'fft';
my $p1 = paths($s);
print "Paths from $s to $e: $p1\n";

%p = ();
$s = 'fft';
$e = 'dac';
my $p2 = paths($s);
print "Paths from $s to $e: $p2\n";

%p = ();
$s = 'dac';
$e = 'out';
my $p3 = paths($s);
print "Paths from $s to $e: $p3\n";

print "Paths: ", $p1*$p2*$p3, "\n";

sub paths {
    my $d = shift;
    return 1 if $d eq $e;
    return $p{$d} if exists $p{$d};
    my $p = 0;
    $p += paths($_) for @{$d{$d}};
    return $p{$d} = $p;
}
