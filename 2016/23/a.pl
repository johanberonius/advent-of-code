#!/usr/bin/perl
use strict;

my @i;
while (<>) {
    my @l = /(\w+) (-?\w+) ?(-?\w+)?/ or die $_;
    push @i => \@l;
}


my %r = (a => 7, b => 0, c => 0, d => 0);
my $c = 0;
my $pc = 0;
while (1) {
    my $l = $i[$pc] or last;
    my ($i, $o1, $o2) = @$l;
    $c++;

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
