#!/usr/bin/perl
use strict;

my @i;
while (<>) {
    my @l = /(\w+) (-?\w+) ?(-?\w+)?/ or die $_;
    push @i => \@l;
}


my %r = (a => 0, b => 0, c => 1, d => 0);
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
            $pc += $o2;
            next;
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
