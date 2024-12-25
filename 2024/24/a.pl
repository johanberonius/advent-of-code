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

while (1) {
    my @k = reverse sort grep /^z/, keys %v;
    my @v = map $v{$_}, @k;
    print map("$_=$v{$_} ", @k), "\n";
    print "Output: ", eval('0b'. join '', @v), "\n";

    last if all { defined $_ } @v;

    for my $g (@g) {
        my ($in1, $op, $in2, $out) = @$g;

        next unless defined $v{$in1} && defined $v{$in2};

        if ($op eq 'AND') {
            $v{$out} = $v{$in1} & $v{$in2};
        } elsif ($op eq 'OR') {
            $v{$out} = $v{$in1} | $v{$in2};
        } elsif ($op eq 'XOR') {
            $v{$out} = $v{$in1} ^ $v{$in2};
        }

        # print "$in1=$v{$in1} $op $in2=$v{$in2} -> $out=$v{$out}\n";
    }
}
