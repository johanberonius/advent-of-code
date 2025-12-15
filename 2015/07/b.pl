#!/usr/bin/perl
use strict;

my %c;
my @i = <>;

while (1) {
    for (@i) {
        if (/^(\w+) -> (\w+)$/) {
            $c{$2} = v($1);
        } elsif (/^(\w+) AND (\w+) -> (\w+)$/) {
            $c{$3} = v($1) & v($2);
        } elsif (/^(\w+) OR (\w+) -> (\w+)$/) {
            $c{$3} = v($1) | v($2);
        } elsif (/^(\w+) LSHIFT (\d+) -> (\w+)$/) {
            $c{$3} = v($1) << $2;
        } elsif (/^(\w+) RSHIFT (\d+) -> (\w+)$/) {
            $c{$3} = v($1) >> $2;
        } elsif (/^NOT (\w+) -> (\w+)$/) {
            $c{$2} = ~v($1) & 0xFFFF;
        } else {
            die $_;
        }
    }
    print "a: $c{a}\n";
}

sub v {
    my $v = shift;
    return 46065 if $v eq 'b';
    $v =~ /^\d+$/ ? 0+$v : $c{$v};
}
