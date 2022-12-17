#!/usr/bin/perl
use strict;
use List::Util qw(all any);

my ($c, %d, %s);
while (<>) {
    $c++;
    /step\s+(\w+).*before.*step\s+(\w+)/i;
    push @{$d{$2}} => $1;
    $d{$1} ||= [];
}

print "$c rules\n";

my $t = -1;
my %t;
$s{$_} = 'todo' for keys %d;
do {
    $t++;
    print "Time: $t\n";

    for my $s (keys %s) {
        if ($s{$s} eq 'doing') {
            if (!--$t{$s}) {
                $s{$s} = 'done';
                print "Done: $s\n";
            } else {
                print "Doing: $s, time left $t{$s}\n";
            }
        }
    }

    for my $s (keys %d) {
        $s{$s} = 'ready' if $s{$s} eq 'todo' && all { $s{$_} eq 'done' } @{$d{$s}};
    }

    my $wa = 5 - grep /doing/, values %s;
    print "Workers available: $wa\n";
    for my $w (1..$wa ) {
        my ($r) = sort grep $s{$_} eq 'ready', keys %s;
        if ($r) {
            $s{$r} = 'doing';
            $t{$r} = ord($r) - 4;
            print "Worker $w starting $r, time left $t{$r}\n";
        }
    }

# use Data::Dumper;
# print Dumper(\%s);

} until (all { /done/ } values %s);

print "Done, time: $t.\n";
