#!/usr/bin/perl
use strict;
use List::Util qw(notall);

my %m;
while (<>) {
    my ($m, $n, $o) = /([&%])?(\w+) -> (\w.*)/ or die;
    my @o = split /,\s*/, $o;
    $m{$n} = [$m, $n, [], [@o], {}];
}

for my $m (values %m) {
    my ($t, $n, $i, $o, $r) = @$m;

    push @{$m{$_}[2]} => $n for @$o;
}

my %cb;
my %cl;
my $b = 0;
b: while (1) {
    $b++;
    my @q = (['button', 0, 'broadcaster']);
    while (@q) {
        my ($s, $p, $d) = @{shift @q};

        if ($p && ($s eq 'vg' || $s eq 'nb' ||$s eq 'vc' ||$s eq 'ls')) {
            print "$s -", ($p ? 'high' : 'low'), "-> $d\n";

            $cl{$s} = $b - $cb{$s};
            print "Button presses: $b, last seen $cb{$s}, cycle $cl{$s}\n";
            $cb{$s} = $b;

            last b if $cl{vg} && $cl{nb} && $cl{vc} && $cl{ls};
        }

        my ($t, $n, $i, $o, $r) = @{$m{$d}};
        if ($t eq '%') {
            if ($p == 0) {
                $r->{$n} = !$r->{$n};
                push @q => [$n, $r->{$n}, $_] for @$o;
            }
        } elsif ($t eq '&') {
            $r->{$s} = $p;
            my $v = notall { $r->{$_} } @$i;
            push @q => [$n, $v, $_] for @$o;
        } else {
            push @q => [$n, $p, $_] for @$o;
        }
    }
}

print "Cycle lengths: $cl{vg} * $cl{nb} * $cl{vc} * $cl{ls} = ", $cl{vg} * $cl{nb} * $cl{vc} * $cl{ls}, "\n";
