#!/usr/bin/perl
use strict;

my $ip;
my @program;
my @r = (0) x 6;

while (<>) {
    $ip = $1 if /#\s*ip\s+(\d+)/;
    push @program => [$1, $2, $3, $4] if /(\w+)\s+(\d+)\s+(\d+)\s+(\d+)/;
}

print "Program length: ", 0+@program, ", ip: $ip\n";

my $pc = 0;
while () {
    my $IP = $r[$ip];
    my @R = @r;
    my ($op, $A, $B, $C) = @{$program[$r[$ip]] or last};

    my %exec = (
        addr => sub {
            $r[$C] = $r[$A] + $r[$B];
        },
        addi => sub {
            $r[$C] = $r[$A] + $B;
        },
        mulr => sub {
            $r[$C] = $r[$A] * $r[$B];
        },
        muli => sub {
            $r[$C] = $r[$A] * $B;
        },
        banr => sub {
            $r[$C] = $r[$A] & $r[$B];
        },
        bani => sub {
            $r[$C] = $r[$A] & $B;
        },
        borr => sub {
            $r[$C] = $r[$A] | $r[$B];
        },
        bori => sub {
            $r[$C] = $r[$A] | $B;
        },
        setr => sub {
            $r[$C] = $r[$A];
        },
        seti => sub {
            $r[$C] = $A;
        },
        gtir => sub {
            $r[$C] = $A > $r[$B] ? 1 : 0;
        },
        gtri => sub {
            $r[$C] = $r[$A] > $B ? 1 : 0;
        },
        gtrr => sub {
            $r[$C] = $r[$A] > $r[$B] ? 1 : 0;
        },
        eqir => sub {
            $r[$C] = $A == $r[$B] ? 1 : 0;
        },
        eqri => sub {
            $r[$C] = $r[$A] == $B ? 1 : 0;
        },
        eqrr => sub {
            $r[$C] = $r[$A] == $r[$B] ? 1 : 0;
        },
    );

    $exec{$op}();

    unless ($pc % 10_000) {
        print "pc=$pc, ip=$IP,\t[", join (', ', map sprintf('%6s', $_), @R), "] $op $A $B $C [", join (', ', map sprintf('%6s', $_), @r), "]\n";
    }
# last if $pc >= 100;

    $r[$ip]++;
    $pc++;
}

print "Program halted after $pc steps\n";
print "ip=$r[$ip], [", join (', ', @r), "]\n";
