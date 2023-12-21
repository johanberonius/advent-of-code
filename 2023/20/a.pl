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

my $h = 0;
my $l = 0;
for (1..1000) {
    my @q = (['button', 0, 'broadcaster']);
    while (@q) {
        my ($s, $p, $d) = @{shift @q};
        $h += $p;
        $l += !$p;

        print "$s -", ($p ? 'high' : 'low'), "-> $d\n";

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

    print "$h high and $l low pules sent.\n\n";
}

print "Result: ", $h * $l, "\n";
