#!/usr/bin/perl
use strict;

my $pc = 0;
my $acc = 0;
my @p;
my @c;
push @p => [$1, 0+$2] while <> =~ /(\w+)\s*([+-]\d+)/;

while ($p[$pc]) {
    my ($i, $n) = @{$p[$pc]};

    if (++$c[$pc] > 1) {
        print "Infinite loop detected at pc $pc: $i $n, acc: $acc\n";
        last;
    }

    if ($i eq 'acc') {
        $acc += $n;
    } elsif ($i eq 'jmp') {
        $pc += $n;
        next;
    }

    $pc++;
}
