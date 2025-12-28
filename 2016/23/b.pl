#!/usr/bin/perl
use strict;

my @i;
while (<>) {
    my @l = /(\w+) (-?\w+) ?(-?\w+)?/ or die $_;
    push @i => \@l;
}


my %r = (a => 12, b => 0, c => 0, d => 0);
my $c = 0;
my $pc = 0;
while (1) {
    my $l = $i[$pc] or last;
    my ($i, $o1, $o2) = @$l;
    $c++;


    if ($i[$pc+5]) {
        my ($i1, $i1o1, $i1o2) = @{$i[$pc+1]};
        my ($i2, $i2o1, $i2o2) = @{$i[$pc+2]};
        my ($i3, $i3o1, $i3o2) = @{$i[$pc+3]};
        my ($i4, $i4o1, $i4o2) = @{$i[$pc+4]};
        my ($i5, $i5o1, $i5o2) = @{$i[$pc+5]};

        if ($i eq 'cpy' && $o1 eq 'b' && $o2 eq 'c' &&

            $i1 eq 'inc' && $i1o1 eq 'a' &&
            $i2 eq 'dec' && $i2o1 eq 'c' &&
            $i3 eq 'jnz' && $i3o1 eq 'c' && $i3o2 == -2 &&

            $i4 eq 'dec' && $i4o1 eq 'd' &&
            $i5 eq 'jnz' && $i5o1 eq 'd' && $i5o2 == -5
        ) {
            $r{a} += $r{b} * $r{d};
            $r{c} = 0;
            $r{d} = 0;
            $pc += 6;
            next;
        }
    }

print "$pc: $i $o1 $o2, a: $r{a}, b: $r{b}, c: $r{c}, d: $r{d}\n";


    if ($i eq 'cpy') {
        $r{$o2} = v($o1);
    } elsif ($i eq 'inc') {
        $r{$o1}++;
    } elsif ($i eq 'dec') {
        $r{$o1}--;
    } elsif ($i eq 'jnz') {
        if (v($o1) != 0) {
            $pc += v($o2);
            next;
        }
    } elsif ($i eq 'tgl') {

        my $t = $i[$pc + v($o1)];
        if ($t) {
            my ($ti, $to1, $to2) = @$t;

            if ($to1 && $to2) {
                if ($ti eq 'jnz') {
                    $t->[0] = 'cpy';
                } else {
                    $t->[0] = 'jnz';
                }
            } elsif ($to1 && !$to2) {
                if ($ti eq 'inc') {
                    $t->[0] = 'dec';
                } else {
                    $t->[0] = 'inc';
                }
            } else {
                die "$ti $to1 $to2";
            }

        }

    } else {
        die $i;
    }

    $pc++;
}

print "Iterations: $c\n";
print "a: $r{a}, b: $r{b}, c: $r{c}, d: $r{d}\n";

sub v {
    my $v = shift;
    $v =~ /^[-+]?\d+$/ ? 0+$v : $r{$v};
}
