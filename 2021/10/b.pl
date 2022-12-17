#!/usr/bin/perl
use strict;

my @s;
my %p = (
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4,
);
my %o = (
    ')' => '(',
    ']' => '[',
    '}' => '{',
    '>' => '<',
);
my %c = (
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>',
);

line: while (<>) {
    chomp;
    my @q;
    for (split '') {
        if (/[(\[{<]/) {
            push @q => $_;
        } elsif ($q[-1] eq $o{$_}) {
            pop @q;
        } else {
            next line;
        }
    }

    my $s = 0;
    for (reverse @q) {
        $s *= 5;
        $s += $p{$c{$_}};
    }

    print "$_ - Complete by adding ", join('', map($c{$_}, reverse @q)) ,". Score: $s\n";
    push @s => $s;
}

print "Number of scores: ", 0+@s, "\n";
print "Middle score: ", (sort { $a <=> $b } @s)[$#s/2], "\n";
