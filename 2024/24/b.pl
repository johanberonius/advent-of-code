#!/usr/bin/perl
use strict;
use List::Util qw(all);

my %v;
my @g;

while (<>) {
    if (/(\w+): (\d)/) {
        $v{$1} = 0+$2;
    } elsif (/(\w+) (\w+) (\w+) -> (\w+)/) {
        for ($1, $3, $4) {
            $v{$_} = undef unless exists $v{$_};
        }
        push @g => [$1, $2, $3, $4];
    }
}

print "Values: ", 0+values %v, "\n";
print "Gates: ", 0+@g, "\n";

my @k = reverse sort grep /^x/, keys %v;
my @v = map $v{$_}, @k;
my $v1 = eval '0b'. join '', @v;

@k = reverse sort grep /^y/, keys %v;
@v = map $v{$_}, @k;
my $v2 = eval '0b'. join '', @v;

my $s = $v1 + $v2;
print "Input values: $v1 + $v2 = $s\n";

my $v;
my %r = (
    kth => 'z12',
    z12 => 'kth',

    gsd => 'z26',
    z26 => 'gsd',

    z32 => 'tbt',
    tbt => 'z32',

    qnf => 'vpm',
    vpm => 'qnf',
);
while (1) {
    my @k = reverse sort grep /^z/, keys %v;
    my @v = map $v{$_}, @k;
    $v = eval('0b'. join '', @v);

    last if all { defined $_ } @v;

    for my $g (@g) {
        my ($in1, $op, $in2, $out) = @$g;

        $out = $r{$out} if $r{$out};

        next unless defined $v{$in1} && defined $v{$in2};

        if ($op eq 'AND') {
            $v{$out} = $v{$in1} & $v{$in2};
        } elsif ($op eq 'OR') {
            $v{$out} = $v{$in1} | $v{$in2};
        } elsif ($op eq 'XOR') {
            $v{$out} = $v{$in1} ^ $v{$in2};
        }
    }
}

print "Output value: $v\n";
