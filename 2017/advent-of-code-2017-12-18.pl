#!/usr/bin/perl
use strict;

my @inst;
while (<>) {
    chomp;
    push @inst => [split /\s+/];
}

my $s = 0;
my $pc = 0;
my %reg;
my $snd;
while ($inst[$pc]) {
    $s++;
    my ($i, $a, $b) = @{$inst[$pc]};
    my ($av, $bv) = map 0+$_ || 0+$reg{$_}, $a, $b;

    if ($i eq 'snd') {
        $snd = $av;
    } elsif ($i eq 'set') {
        $reg{$a} = $bv;
    } elsif ($i eq 'add') {
        $reg{$a} += $bv;
    } elsif ($i eq 'mul') {
        $reg{$a} *= $bv;
    } elsif ($i eq 'mod') {
        $reg{$a} %= $bv;
    } elsif ($i eq 'rcv' and $av) {
        print "rcv $snd\n";
        last;
    } elsif ($i eq 'jgz' and $av > 0) {
        $pc += $bv;
        next;
    }

    $pc++;
}

print "Program ended after $s steps.\n";
