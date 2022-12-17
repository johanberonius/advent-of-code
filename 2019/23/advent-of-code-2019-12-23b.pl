#!/usr/bin/perl
use strict;
use List::Util qw(sum);

my @b = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@b, "\n";

my @prg;
my @pc;
my @r;
my @in;
my @out;
my $naty;

print "Starting... \n";
$in[255] = [];
for my $pid (0..49) {
    start($pid);
}

print "Running...\n";
while (1) {
   for my $pid (0..49) {
        run($pid);
    }
}



sub start {
    my $pid = shift;
    $pc[$pid] = 0;
    $r[$pid] = 0;
    $prg[$pid] = [@b];
    $in[$pid] = [$pid];
    $out[$pid] = [];
}

sub run {
    my $pid = shift;
    my @p = @{$prg[$pid]};
    my $pc = $pc[$pid];
    my $r = $r[$pid];

    my $t = 100;
    while ($t--) {
        die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

        my $i = $p[$pc] % 100;
        my @m = reverse split '', int($p[$pc] / 100);
        $pc++;

        my $param = sub {
            my $w = shift;
            my $m = shift @m;
            my $a = $p[$pc++];
            $a = $r + $a if $m == 2;
            die "Immediate mode not valid for write parameter" if $w && $m == 1;
            $a = $p[$a] if ($m == 0 || $m == 2) && !$w;
            return $a;
        };

        # ADD, MUL, LESS THAN, EQUALS
        if ($i == 1 || $i == 2 || $i == 7 || $i == 8) {
            my $a = $param->();
            my $b = $param->();
            my $c = $param->('w');

            $p[$c] = $a + $b if $i == 1;
            $p[$c] = $a * $b if $i == 2;
            $p[$c] = 0+($a < $b) if $i == 7;
            $p[$c] = 0+($a == $b) if $i == 8;
        }
        # INPUT
        elsif ($i == 3) {
            my $a = $param->('w');
            my $b = @{$in[$pid]} ? shift @{$in[$pid]} : -1;
            # print "Input in $pid at $pc: $b\n";
            $p[$a] = $b;

            if ($b == -1) {
                my $iq = sum map 0+@{$in[$_]}, 0..49;
                if ($iq == 0 and @{$in[255]} > 0) {
                    my ($x, $y) = @{$in[255]};
                    print "Network is idle. NAT package sent to pid 0: $x, $y\n";
                    push @{$in[0]} => ($x, $y);
                    $in[255] = [];

                    die "NAT Y value sent twice in a row: $y\n" if $naty == $y;
                    $naty = $y;
                }
            }

        }
        # OUTPUT
        elsif ($i == 4) {
            my $a = $param->();
            push @{$out[$pid]} => $a;
            if (@{$out[$pid]} >= 3) {
                my $y = pop @{$out[$pid]};
                my $x = pop @{$out[$pid]};
                my $d = pop @{$out[$pid]};

                if ($d == 255) {
                    print "Y: $y sent to address $d.\n";
                    @{$in[$d]} = ($x, $y);
                } else {
                    push @{$in[$d]} => ($x, $y);
                }
            }
        }
        # JUMP if true, JUMP if false
        elsif ($i == 5 || $i == 6) {
            my $a = $param->();
            my $b = $param->();

            if ($i == 5 && $a or $i == 6 && !$a) {
                $pc = $b;
                next;
            }
        }
        # RELATIVE BASE
        elsif ($i == 9) {
            my $a = $param->();
            $r += $a;
        }
        # HALT
        elsif ($i == 99) {
            print "Program $pid halted.\n";
            push @{$out[$pid]} => 'HALT';
            last;
        } else {
            die "Unknown inctruction: $i in program: $pid at pc: $pc";
        }
    }

    @{$prg[$pid]} = @p;
    $pc[$pid] = $pc;
    $r[$pid] = $r;

    return @{$out[$pid]};
}
