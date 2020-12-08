#!/usr/bin/perl
use strict;

my @p;
push @p => [$1, 0+$2] while <> =~ /(\w+)\s*([+-]\d+)/;

my $r;
my $c = 0;
for my $p (0..$#p) {
    my ($i, $n) = @{$p[$p]};

    if ($i eq 'jmp') {
        $i = 'nop';
    } elsif ($i eq 'nop') {
        $i = 'jmp';
    } else {
        next;
    }

    $c++;

    last if $r = run(@p[0..$p-1], [$i, $n], @p[$p+1..$#p]);
}

print "Program terminated after $c altered instructions, acc: $r\n";


sub run {
    my @p = @_;
    my @c;
    my $pc = 0;
    my $acc = 0;

    while ($p[$pc]) {
        my ($i, $n) = @{$p[$pc]};

        if (++$c[$pc] > 1) {
            return 0;
        }

        if ($i eq 'acc') {
            $acc += $n;
        } elsif ($i eq 'jmp') {
            $pc += $n;
            next;
        }

        $pc++;
    }

    return $acc;
}
