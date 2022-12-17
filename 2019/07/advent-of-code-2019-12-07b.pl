#!/usr/bin/perl
use strict;

my @b = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@b, "\n";

my %t;
my $c = 0;
my $f = 0;
for my $p (permutations(5..9)) {
    $c++;
    my $o = 0;
    ($o) = start(0, $p->[0], $o);
    ($o) = start(1, $p->[1], $o);
    ($o) = start(2, $p->[2], $o);
    ($o) = start(3, $p->[3], $o);
    ($o) = start(4, $p->[4], $o);
    $t{join ',', @$p} = $o if $o ne 'HALT';

    while ($o ne 'HALT') {
        $f++;
        ($o) = run(0, $o);
        ($o) = run(1, $o);
        ($o) = run(2, $o);
        ($o) = run(3, $o);
        ($o) = run(4, $o);
        $t{join ',', @$p} = $o if $o ne 'HALT';
    }
}

print "Tested $c combinations.\n";
print "Ran $f feedback loops.\n";
my ($k) = sort { $t{$b} <=> $t{$a} } keys %t;
print "Max thruster signal: $t{$k}\n";
print "Phase setting sequence: $k\n";

my @prg;
my @pc;
sub start {
    my $pid = shift;
    $pc[$pid] = 0;
    $prg[$pid] = [@b];
    return run($pid, @_);
}

sub run {
    my $pid = shift;
    my $o;
    my @p = @{$prg[$pid]};
    my $pc = $pc[$pid];
    while (1) {
        die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

        my $i = $p[$pc] % 100;
        my @m = reverse split '', int($p[$pc] / 100);
        $pc++;

        # ADD, MUL, LESS THAN, EQUALS
        if ($i == 1 || $i == 2 || $i == 7 || $i == 8) {
            my $a = $p[$pc++];
            my $b = $p[$pc++];
            my $c = $p[$pc++];
            $a = $p[$a] unless $m[0];
            $b = $p[$b] unless $m[1];
            die "Immediate mode not valid for write parameter" if $m[2];
            $p[$c] = $a + $b if $i == 1;
            $p[$c] = $a * $b if $i == 2;
            $p[$c] = 0+($a < $b) if $i == 7;
            $p[$c] = 0+($a == $b) if $i == 8;
        }
        # INPUT
        elsif ($i == 3) {
            my $a = $p[$pc++];
            die "Immediate mode not valid for write parameter" if $m[0];
            my $b = 0+shift;
            print "Input: $b\n";
            $p[$a] = $b;
        }
        # OUTPUT
        elsif ($i == 4) {
            my $a = $p[$pc++];
            $a = $p[$a] unless $m[0];
            print "Output: $a\n";
            $o = $a;
            last;
        }
        # JUMP if true, JUMP if false
        elsif ($i == 5 || $i == 6) {
            my $a = $p[$pc++];
            my $b = $p[$pc++];
            $a = $p[$a] unless $m[0];
            $b = $p[$b] unless $m[1];
            if ($i == 5 && $a or $i == 6 && !$a) {
                $pc = $b;
                next;
            }
        }
        # HALT
        elsif ($i == 99) {
            print "Program halted.\n";
            $o = 'HALT';
            last;
        } else {
            die "Unknown inctruction: $i";
        }
    }

    @{$prg[$pid]} = @p;
    $pc[$pid] = $pc;

    return $o;
}

sub permutations {
    my @a = @_;
    my $n = @a;
    my @r = ([@a]);
    my @c;
    my $i = 0;
    while ($i < $n) {
        if ($c[$i] < $i) {
            if ($i % 2) {
                ($a[$i], $a[$c[$i]]) = ($a[$c[$i]], $a[$i]);
            } else {
                ($a[$i], $a[0]) = ($a[0], $a[$i]);
            }
            push @r => [@a];
            $c[$i]++;
            $i = 0;
        } else {
            $c[$i] = 0;
            $i++;
        }
    }
    return @r;
}
