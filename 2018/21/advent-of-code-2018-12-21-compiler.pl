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
print "use strict;\n";
print "my (\$r0, \$r1, \$r3, \$r4, \$r5);\n";
while () {
    my ($op, $A, $B, $C) = @{$program[$pc] or last};

    print "l$pc: ";

    my $rA = $A == $ip ? $pc : "\$r$A";
    my $rB = $B == $ip ? $pc : "\$r$B";

    my %exec = (
        addr => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA + $rB + 1);";
            } else {
                print "\$r$C = $rA + $rB;";
            }
        },
        addi => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA + ", $B + 1, ");";
            } else {
                print "\$r$C = $rA + $B;";
            }
        },
        mulr => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA * $rB);";
            } else {
                print "\$r$C = $rA * $rB;";
            }
        },
        muli => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA * $B + 1);";
            } else {
                print "\$r$C = $rA * $B;";
            }
        },
        banr => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA & $rB);";
            } else {
                $r[$C] = $r[$A] & $r[$B];
                print "\$r$C = $rA & $rB;";
            }
        },
        bani => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA & $B + 1);";
            } else {
                print "\$r$C = $rA & $B;";
            }
        },
        borr => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA | $rB + 1);";
            } else {
                print "\$r$C = $rA | $rB;";
            }
        },
        bori => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA | $B + 1);";
            } else {
                print "\$r$C = $rA | $B;";
            }
        },
        setr => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA + 1);";
            } else {
                print "\$r$C = $rA;";
            }
        },
        seti => sub {
            if ($C == $ip) {
                print "goto l", $A + 1, ";";
            } else {
                print "\$r$C = $A;";
            }
        },
        gtir => sub {
            if ($C == $ip) {
                print "goto 'l'.($A > $rB ? 2 : 1);";
            } else {
                print "\$r$C = $A > $rB;";
            }
        },
        gtri => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA > $B ? 2 : 1);";
            } else {
                print "\$r$C = $rA > $B;";
            }
        },
        gtrr => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA > $rB ? 2 : 1);";
            } else {
                print "\$r$C = $rA > $rB;";
            }
        },
        eqir => sub {
            if ($C == $ip) {
                print "goto 'l'.($A == $rB ? 2 : 1);";
            } else {
                print "\$r$C = $A == $rB;";
            }
        },
        eqri => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA == $B ? 2 : 1);";
            } else {
                print "\$r$C = $rA == $B;";
            }
        },
        eqrr => sub {
            if ($C == $ip) {
                print "goto 'l'.($rA == $rB ? 2 : 1);";
            } else {
                print "\$r$C = $rA == $rB;";
            }
        },
    );

    $exec{$op}();
    print "\n";

    $pc++;
}

print "Program interpeted after $pc steps\n";
