#!/usr/bin/perl
use strict;
use List::Util qw(max);

my $b = 0;
my $c = 0;
my $g = 0;
my $n = 0;
my $m = 0;
my $s = 0;
my $p = 0;

$/ = \1;
while (<>) {
    next if $g && /!/ ... /./;
    if (/</ ... />/) {
        $b++ unless !$g || />/;
        $g = 1;
        next;
    }
    $g = 0;
    ++$n and $s += ++$p if /{/;
    print ' ' x (($p - 1) * 2) . "$_\n" unless /,/;
    $m = max $m, $p;
    --$p if /}/;
    $c++;
}

print <<END;
Garbage characters: $b
Non garbage characters: $c
Number of groups: $n
Deepest nesting level: $m
Total score: $s
END
