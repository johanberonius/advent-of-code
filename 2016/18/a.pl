#!/usr/bin/perl
use strict;

$_ = <>;
chomp;
my @t = map $_ eq '^', split '';

my $c = 0;
for (1..40) {
    print map($_ ? '^' : '.', @t), "\n";
    $c += !$_ for @t;

    @t = map {
        my ($l, $c, $r) = @t[$_-1..$_+1];
        $l = 0 if $_ == 0;
        $r = 0 if $_ == $#t;

         $l &&  $c && !$r or
        !$l &&  $c &&  $r or
         $l && !$c && !$r or
        !$l && !$c &&  $r;
    } 0..$#t;
}

print "Safe tiles: $c\n";
