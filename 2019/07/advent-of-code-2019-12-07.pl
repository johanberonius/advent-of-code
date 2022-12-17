#!/usr/bin/perl
use strict;

my @b = map 0+$_, split ',', <>;
print "Program loaded, length: ", 0+@b, "\n";

my %t;
my $c = 0;

# for my $i1 (0..4) {
#     for my $i2 (grep $_ != $i1, 0..4) {
#         for my $i3 (grep $_ != $i1 && $_ != $i2, 0..4) {
#             for my $i4 (grep $_ != $i1 && $_ != $i2 && $_ != $i3, 0..4) {
#                 for my $i5 (grep $_ != $i1 && $_ != $i2 && $_ != $i3 && $_ != $i4, 0..4) {
#                     $c++;
#                     my $o = 0;
#                     ($o) = run($i1, $o);
#                     ($o) = run($i2, $o);
#                     ($o) = run($i3, $o);
#                     ($o) = run($i4, $o);
#                     ($o) = run($i5, $o);
#                     $t{"$i1,$i2,$i3,$i4,$i5"} = $o;
#                 }
#             }
#         }
#     }
# }

for (permutations(0..4)) {
    $c++;
    my $o = 0;
    ($o) = run($_->[0], $o);
    ($o) = run($_->[1], $o);
    ($o) = run($_->[2], $o);
    ($o) = run($_->[3], $o);
    ($o) = run($_->[4], $o);
    $t{join ',', @$_} = $o;
}

print "Tested $c combinations.\n";
my ($k) = sort { $t{$b} <=> $t{$a} } keys %t;
print "Max thruster signal: $t{$k}\n";
print "Phase setting sequence: $k\n";


sub run {
    my @o;
    my @p = @b;
    my $pc = 0;
    while (1) {
        die "Program counter out of bounds: $pc" if $pc < 0 || $pc > $#p;

        my $i = $p[$pc] % 100;
        my @m = reverse split '', int($p[$pc] / 100);

        # ADD, MUL, LESS THAN, EQUALS
        if ($i == 1 || $i == 2 || $i == 7 || $i == 8) {
            my $a = $p[++$pc];
            my $b = $p[++$pc];
            my $c = $p[++$pc];
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
            my $a = $p[++$pc];
            die "Immediate mode not valid for write parameter" if $m[0];
            my $b = 0+shift;
            print "Input: $b\n";
            $p[$a] = $b;
        }
        # OUTPUT
        elsif ($i == 4) {
            my $a = $p[++$pc];
            $a = $p[$a] unless $m[0];
            print "Output: $a\n";
            push @o => $a;
        }
        # JUMP if true, JUMP if false
        elsif ($i == 5 || $i == 6) {
            my $a = $p[++$pc];
            my $b = $p[++$pc];
            $a = $p[$a] unless $m[0];
            $b = $p[$b] unless $m[1];
            if ($i == 5 && $a or $i == 6 && !$a) {
                $pc = $b;
                next;
            }
        }
        # HALT
        elsif ($i == 99) {
            last;
        } else {
            die "Unknown inctruction: $i";
        }

        $pc++;
    }
    print "Program halted.\n";
    return @o;
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
