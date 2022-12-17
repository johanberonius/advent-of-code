#!/usr/bin/perl
use strict;

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

my $n = grep /$re/, @m;
print "Matching messages: $n\n";


sub re {
    my $r = shift;
    return $r{$r} unless ref $r{$r};

    my $re = '(';

    for my $sr (@{$r{$r}[0]}) {
        $re .= re($sr);
    }

    if (@{$r{$r}[1]}) {
        $re .= '|';
        for my $sr (@{$r{$r}[1]}) {
            $re .= re($sr);
        }
    }

    $re .= ')';
    return $re;
}
