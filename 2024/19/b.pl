#!/usr/bin/perl
use strict;

$_ = <>;
chomp;
my @t = split /\s*,\s*/;
my @d = map { chomp; $_ || () } <>;

print "Towels: ", 0+@t, "\n";
print "Designs: ", 0+@d, "\n";

my $re = join '|', @t;
my $t = 0;
my $i = 0;
for my $sd (@d) {
    print "Testing design: $sd\n";
    my @q = ($sd);
    my $c = 0;
    while (@q) {
        my $d = shift @q;
        next unless $d =~ /^($re)+$/;

        for my $t (@t) {
            if ($d eq $t) {
                $c++;
            } elsif (rindex($d, $t, 0) == 0) {
                push @q => substr($d, length($t));
            }
        }

        print "Testing design: $d\nIterations: $i, combinations: $c, queue size: ", 0+@q, "\n" unless $i % 100_000;
        $i++;
    }
    print "Possible combinations for $sd: $c\n";
    $t += $c;
}

print "Sum of possible combinations: $t\n";
