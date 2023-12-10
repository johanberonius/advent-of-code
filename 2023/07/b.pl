#!/usr/bin/perl
use strict;
use List::Util qw(min);

my %v = (T => 10, J => 1, Q => 12, K => 13, A => 14);
my @h;
while (<>) {
    if (/(\w{5}) (\d+)/) {
        my $h = {
            hand => $1,
            cards => [map 0+$_ || $v{$_}, split '', $1],
            bid => 0+$2
        };

        my %t;
        my $j = 0;
        for my $c (@{$h->{cards}}) {
            if ($c != 1) {
                $t{$c}++;
            } else {
                $j++;
            }
        }
        my %d;
        $d{$_}++ for values %t;

        $h->{types}{1} = $d{1} + $j;
        $h->{types}{2} = $d{2} + ($d{1} && $j >= 1) + ($j >= 2);
        $h->{types}{3} = $d{3} + ($d{2} && $j >= 1) + ($d{1} && $j >= 2) + ($j >= 3);
        $h->{types}{4} = $d{4} + ($d{3} && $j >= 1) + ($d{2} && $j >= 2) + ($d{1} && $j >= 3) + ($j >= 4);
        $h->{types}{5} = $d{5} + ($d{4} && $j >= 1) + ($d{3} && $j >= 2) + ($d{2} && $j >= 3) + ($d{1} && $j >= 4) + ($j >= 5);
        $h->{types}{'3+2'} = ($d{3} && $d{2}) +
                             ($d{3} && $d{1} && $j >= 1) +
                             ($d{2} >= 2 && $j >= 1) +
                             ($d{3} && $j >= 2) +
                             ($d{2} && $d{1} && $j >= 2) +
                             ($d{2} && $j >= 3) +
                             ($d{1} >= 2 && $j >= 3) +
                             ($d{1} && $j >= 4) +
                             ($j >= 5);

        $h->{type} = $h->{types}{5} ?     50 :
                     $h->{types}{4} ?     40 :
                     $h->{types}{'3+2'} ? 32 :
                     $h->{types}{3} ?     30 :
                     $h->{types}{2}>=2 ?  22 :
                     $h->{types}{2}>=1 ?  20 :
                     $h->{types}{1}>=5 ?  10 : 0;

        push @h => $h;
    }
}

my $rank = 1;
my $win = 0;
for my $h (sort {
    $a->{type} <=> $b->{type} or
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

print "Total winnings: $win\n";
