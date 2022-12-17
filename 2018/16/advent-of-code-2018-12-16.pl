#!/usr/bin/perl
use strict;

my $sample;
my @samples;
my @program;
while (<>) {
    if (my @numbers = /^\s*Before:\s+\[\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\s*\]\s*$/i) {
        $sample = { before => \@numbers };
    }

    if (my @numbers = /^\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s*$/) {
        if ($sample) {
            $sample->{instruction} = \@numbers;
        } else {
            push @program => \@numbers;
        }
    }

    if (my @numbers = /^\s*After:\s+\[\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\s*\]\s*$/i) {
        $sample->{after} = \@numbers;
        push @samples => $sample;
        undef $sample;
    }
}

print 0+@samples, " samples\n";
print 0+@program, " instructions in program\n";


my $c = 0;
for my $sample (@samples) {
    my $matches = 0;
    my ($opcode, $A, $B, $C) = @{$sample->{instruction}};

    addr: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] + $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    addi: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] + $B;
        $matches++ if equals(\@r, $sample->{after});
    }

    mulr: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] * $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    muli: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] * $B;
        $matches++ if equals(\@r, $sample->{after});
    }

    banr: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] & $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    bani: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] & $B;
        $matches++ if equals(\@r, $sample->{after});
    }

    borr: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] | $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    bori: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] | $B;
        $matches++ if equals(\@r, $sample->{after});
    }

    setr: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A];
        $matches++ if equals(\@r, $sample->{after});
    }

    seti: {
        my @r = @{$sample->{before}};
        $r[$C] = $A;
        $matches++ if equals(\@r, $sample->{after});
    }

    gtir: {
        my @r = @{$sample->{before}};
        $r[$C] = $A > $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    gtri: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] > $B;
        $matches++ if equals(\@r, $sample->{after});
    }

    gtrr: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] > $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    eqir: {
        my @r = @{$sample->{before}};
        $r[$C] = $A == $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    eqri: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] == $B;
        $matches++ if equals(\@r, $sample->{after});
    }

    eqrr: {
        my @r = @{$sample->{before}};
        $r[$C] = $r[$A] == $r[$B];
        $matches++ if equals(\@r, $sample->{after});
    }

    # print "Matches $matches opcodes.\n";
    $c++ if $matches >= 3;

# last if $c >= 2;
}

print "Samples matching 3 or more opcodes: $c\n";



sub equals {
    my $a = shift;
    my $b = shift;
    $a->[0] == $b->[0] &&
    $a->[1] == $b->[1] &&
    $a->[2] == $b->[2] &&
    $a->[3] == $b->[3];
}
