#!/usr/bin/perl
use strict;


my @n = map [map 0+$_, /([01])/g], <>;
print "Numbers: ", 0+@n, "\n";

my @ogn = @n;
for my $b (0..@{$ogn[0]}-1) {

    my $c = grep $_, map $_->[$b], @ogn;

    my @b = map $_->[$b], @ogn;
    print "Bits: @b\n";

    my $mc = 0+($c >= @ogn / 2);

    @ogn = grep $_->[$b] == $mc, @ogn;

    print "Bit: $b, most common: $mc, keep ", 0+@ogn, " numbers.\n";
    last if @ogn == 1;
}

my $og = eval '0b' . join '', @{$ogn[0]};
print "Oxygen generator: $og\n";


my @con = @n;
for my $b (0..@{$con[0]}-1) {

    my $c = grep $_, map $_->[$b], @con;

    my @b = map $_->[$b], @con;
    print "Bits: @b\n";

    my $lc = 0+($c < @con / 2);

    @con = grep $_->[$b] == $lc, @con;

    print "Bit: $b, least common: $lc, keep ", 0+@con, " numbers.\n";
    last if @con == 1;
}

my $co = eval '0b' . join '', @{$con[0]};
print "CO2 scrubber: $co\n";


print "Life suport rating: ", $og * $co, "\n";
