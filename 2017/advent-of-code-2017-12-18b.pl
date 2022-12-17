#!/usr/bin/perl
use strict;

my @inst;
while (<>) {
    chomp;
    push @inst => [split /\s+/];
}

my $p0 = {prg => 0, p => 0};
my $p1 = {prg => 1, p => 1};
my $q0 = [];
my $q1 = [];

while (1) {
    my @q1 = run($p0, $q0);
    push @$q1 => @q1;
    print "Program $p0->{'prg'} ran $p0->{'stp'} steps and yielded ", scalar @q1, " values.\n";
    last unless $p0->{'stp'} || $p1->{'stp'};

    my @q0 = run($p1, $q1);
    push @$q0 => @q0;
    print "Program $p1->{'prg'} ran $p1->{'stp'} steps and yielded ", scalar @$q0, " values.\n";
    last unless $p0->{'stp'} || $p1->{'stp'};
}

print "Program $p0->{'prg'} ran $p0->{'clk'} intructions over $p0->{'run'} runs, sent $p0->{'snd'} and received $p0->{'rcv'} values.\n";
print "Program $p1->{'prg'} ran $p1->{'clk'} intructions over $p1->{'run'} runs, sent $p1->{'snd'} and received $p1->{'rcv'} values.\n";


sub run {
    my ($reg, $in) = @_;
    my @out;
    $reg->{'run'}++;
    $reg->{'stp'} = 0;
    while ($reg->{'pc'} >= 0 and $inst[ $reg->{'pc'} ]) {
        my ($i, $a, $b) = @{$inst[ $reg->{'pc'} ]};
        my ($av, $bv) = map 0+$_ || 0+$reg->{$_}, $a, $b;
        $reg->{'clk'}++;

        if ($i eq 'snd') {
            $reg->{'snd'}++;
            push @out => $av;
        } elsif ($i eq 'set') {
            $reg->{$a} = $bv;
        } elsif ($i eq 'add') {
            $reg->{$a} += $bv;
        } elsif ($i eq 'mul') {
            $reg->{$a} *= $bv;
        } elsif ($i eq 'mod') {
            $reg->{$a} %= $bv;
        } elsif ($i eq 'rcv') {
            @$in or return @out;
            $reg->{$a} = shift @$in;
            $reg->{'rcv'}++;
        } elsif ($i eq 'jgz') {
            if ($av > 0) {
                $reg->{'stp'}++;
                $reg->{'pc'} += $bv;
                next;
            }
        } else {
            die "Unmatched intruction '$i $a:$av $b:$bv' at $reg->{'pc'} in program $reg->{'prg'}\n";
        }

        $reg->{'stp'}++;
        $reg->{'pc'}++;
    }

    warn "Instruction buffer overflow at $reg->{'pc'} in program $reg->{'prg'}\n";
}
