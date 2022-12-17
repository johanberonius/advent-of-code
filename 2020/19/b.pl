#!/usr/bin/perl
use strict;
use List::Util qw(any);

my %r;
my @m;
while (<>) {
    chomp;

    if (1../^$/) {
        if (/(\d+):\s*"(.*?)"/) {
            $r{$1} = $2;
        } elsif (/(\d+):\s*((?:\d+\s*)+)(?:\s*\|\s*((?:\d+\s*)+))?/) {
            $r{$1} = [[split /\s+/, $2], [split /\s+/, $3]];
        }
    } else {
        push @m => $_;
    }
}


print "Rules: ", 0+keys %r, "\n";
print "Messages: ", 0+@m, "\n";

my $re = '^' . re(0) . '$';
print "Regexp: /$re/\n";

my $n = grep {
    my $m = $_;
    any {
        $re =~ s/{\d+}/{$_}/g;
        $m =~ /$re/;
    } 1..4;
} @m;
print "Matching messages: $n\n";


sub re {
    my $r = shift;
    return $r{$r} unless ref $r{$r};

    my $re = '(';

    for my $sr (@{$r{$r}[0]}) {
        $re .= re($sr);
        $re .= '{1}' if $r == 11;
        $re .= '+' if $r == 8;
    }

    unless ($r == 8 or $r == 11) {
        if (@{$r{$r}[1]}) {
            $re .= '|';
            for my $sr (@{$r{$r}[1]}) {
                $re .= re($sr);
            }
        }
    }

    $re .= ')';
    return $re;
}
