#!/usr/bin/perl
use strict;
use List::Util qw(max);

my %v = (T => 10, J => 11, Q => 12, K => 13, A => 14);
my @h;
while (<>) {
    if (/(\w{5}) (\d+)/) {
        my $h = {
            hand => $1,
            cards => [map 0+$_ || $v{$_}, split '', $1],
            bid => 0+$2
        };

        my %t;
        $t{$_}++ for @{$h->{cards}};
        $h->{types}{$_}++ for values %t;

        push @h => $h;
    }
}

my $rank = 1;
my $win = 0;
for my $h (sort {
    ($a->{types}{5}>0) <=> ($b->{types}{5}>0) or
    ($a->{types}{4}>0) <=> ($b->{types}{4}>0) or
    ($a->{types}{3}>0 && $a->{types}{2}>0) <=> ($b->{types}{3}>0 && $b->{types}{2}>0) or
    ($a->{types}{3}>0) <=> ($b->{types}{3}>0) or
    ($a->{types}{2}>=2) <=> ($b->{types}{2}>=2) or
    ($a->{types}{2}>=1) <=> ($b->{types}{2}>=1) or
    ($a->{types}{1}>=5) <=> ($b->{types}{1}>=5) or
    $a->{cards}[0] <=> $b->{cards}[0] or
    $a->{cards}[1] <=> $b->{cards}[1] or
    $a->{cards}[2] <=> $b->{cards}[2] or
    $a->{cards}[3] <=> $b->{cards}[3] or
    $a->{cards}[4] <=> $b->{cards}[4]
    } @h) {
    $h->{rank} = $rank++;
    $h->{win} = $h->{bid} * $h->{rank};
    $win += $h->{win};

    print "Rank $h->{rank}, hand $h->{hand}, bid $h->{bid}, win $h->{win}\n";
}

# use Data::Dumper;
# print Dumper(\@h);

print "Total winnings: $win\n";
