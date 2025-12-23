#!/usr/bin/perl
use strict;
use List::Util qw(min max);

my %b;
my %o;
my %c;
while (<>) {
    if (/value (\d+) goes to bot (\d+)/) {
        push @{$b{$2}} => $1;
    } elsif (/bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)/) {
        $c{$1} = [$2, $3, $4, $5];
    } else {
        die $_;
    }
}

l: while (1) {
    my $c;
    for my $b (keys %b) {
        my @v = @{$b{$b}};

        if (@v == 2) {
            # print "Bot $b has two chips @v, ";
            $c++;
            my ($tl, $nl, $th, $nh) = @{$c{$b}} or die;
            my $max = max @v;
            my $min = min @v;
            # print " ($th, $nh, $tl, $nl) $min < $max, ";

            if ($th eq 'bot') {
                # print "$max to bot $nh";
                push @{$b{$nh}} => $max;
            } elsif ($th eq 'output') {
                $o{$nh} = $max;
                print "$max to output $nh\n";
            } else {
                die $th;
            }

            if ($tl eq 'bot') {
                push @{$b{$nl}} => $min;
                # print "$min to bot $nl";
            } elsif ($tl eq 'output') {
                $o{$nl} = $min;
                print "$min to output $nl\n";
            } else {
                die $tl;
            }

            delete $b{$b};
        }
    }
    last unless $c;
}

print "Outputs: $o{0} * $o{1} * $o{2} = ", $o{0} * $o{1} * $o{2}, "\n";
