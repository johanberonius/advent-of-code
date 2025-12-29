#!/usr/bin/perl
use strict;

my @i;
while (<>) {
    my @l = /(\w+) (-?\w+) ?(-?\w+)?/ or die $_;
    push @i => \@l;
}


my %r;
my $ia = 0;
ia: while (1) {
    my $po;

    %r = (a => $ia, b => 0, c => 0, d => 0);
    print "Starting with a: $r{a}, b: $r{b}, c: $r{c}, d: $r{d}\n";
    my $pc = 0;
    while (1) {
        my $l = $i[$pc] or last;
        my ($i, $o1, $o2) = @$l;

        if ($i eq 'cpy') {
            $r{$o2} = v($o1);
        } elsif ($i eq 'inc') {
            $r{$o1}++;
        } elsif ($i eq 'dec') {
            $r{$o1}--;
        } elsif ($i eq 'jnz') {
            if (v($o1) != 0) {
                $pc += $o2;
                next;
            }
        } elsif ($i eq 'out') {
            my $o = v($o1);
            $po = !$o unless defined $po;
            next ia unless $o == !$po;
            $po = $o;
        } else {
            die $i;
        }

        $pc++;
    }

} continue {
    $ia++;
    last if $ia > 184;
}

sub v {
    my $v = shift;
    $v =~ /^[-+]?\d+$/ ? 0+$v : $r{$v};
}
