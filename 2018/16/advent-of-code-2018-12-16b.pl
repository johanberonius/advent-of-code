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

my %opcodes;
my %mnemonics;
while () {
    my %matching_opcodes;
    for my $sample (@samples) {
        my ($opcode, $A, $B, $C) = @{$sample->{instruction}};
        next if $opcodes{$opcode};

        addr: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'addr';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] + $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        addi: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'addi';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] + $B;
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        mulr: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'mulr';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] * $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        muli: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'muli';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] * $B;
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        banr: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'banr';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] & $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        bani: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'bani';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] & $B;
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        borr: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'borr';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] | $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        bori: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'bori';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] | $B;
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        setr: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'setr';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        seti: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'seti';
            last if $mnemonics{$mnemonic};
            $r[$C] = $A;
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        gtir: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'gtir';
            last if $mnemonics{$mnemonic};
            $r[$C] = $A > $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        gtri: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'gtri';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] > $B;
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        gtrr: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'gtrr';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] > $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        eqir: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'eqir';
            last if $mnemonics{$mnemonic};
            $r[$C] = $A == $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        eqri: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'eqri';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] == $B;
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }

        eqrr: {
            my @r = @{$sample->{before}};
            my $mnemonic = 'eqrr';
            last if $mnemonics{$mnemonic};
            $r[$C] = $r[$A] == $r[$B];
            $matching_opcodes{$opcode}{$mnemonic}++ if equals(\@r, $sample->{after});
        }
    }

    for my $opcode (keys %matching_opcodes) {
        my @mnemonics = keys %{$matching_opcodes{$opcode}};
        if (@mnemonics == 1) {
            $opcodes{$opcode} = $mnemonics[0];
            $mnemonics{$mnemonics[0]} = 1;
            print "Opcode $opcode is '$mnemonics[0]'\n";
        }
    }

    last if keys %opcodes == 16;
}




my @r = (0, 0, 0, 0);
for my $instruction (@program) {
    my ($opcode, $A, $B, $C) = @{$instruction};

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
            $r[$C] = $A > $r[$B];
        },
        gtri => sub {
            $r[$C] = $r[$A] > $B;
        },
        gtrr => sub {
            $r[$C] = $r[$A] > $r[$B];
        },
        eqir => sub {
            $r[$C] = $A == $r[$B];
        },
        eqri => sub {
            $r[$C] = $r[$A] == $B;
        },
        eqrr => sub {
            $r[$C] = $r[$A] == $r[$B];
        },
    );

    $exec{$opcodes{$opcode}}();

    print "$opcodes{$opcode} $A, $B, $C => [@r]\n";
}


sub equals {
    my $a = shift;
    my $b = shift;
    $a->[0] == $b->[0] &&
    $a->[1] == $b->[1] &&
    $a->[2] == $b->[2] &&
    $a->[3] == $b->[3];
}
