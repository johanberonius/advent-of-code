#!/usr/bin/perl
use strict;
use List::Util qw(any sum);

my @r;
while (<>) {
    if (/(\d+)-(\d+)/) {
        push @r => {min => $1, max => $2};
    }
}

print "Ranges: ", 0+@r, "\n";

my @u;
# Union of all ranges
for my $r (@r) {
    # print "Checking $r->{min} - $r->{max}\n";

    # Skip $r if any range in @u covers it
    if (any { $_->{min} <= $r->{min} && $r->{max} <= $_->{max} } @u) {
        # print "Skip $r->{min} - $r->{max}\n";
        next;
    }

    # Remove any ranges in @u that are covered by $r
    @u = grep { not $r->{min} <= $_->{min} && $_->{max} <= $r->{max} } @u;

    # If any range in @u includes $r->{min}, remove it from @u and change $r->{min} to $u->{min}
    for my $i (0..$#u) {
        my $u = $u[$i];
        if ($u->{min} <= $r->{min} && $r->{min} <= $u->{max} + 1) {
            splice @u, $i, 1;
            # print "Removing $u->{min} - $u->{max}\n";
            $r->{min} = $u->{min};
            # print "Changing to $r->{min} - $r->{max}\n";
            last;
        }
    }

    # If any range in @u includes $r->{max}, remove it from @u and change $r->{max} to $u->{max}
    for my $i (0..$#u) {
        my $u = $u[$i];
        if ($u->{min} - 1 <= $r->{max} && $r->{max} <= $u->{max}) {
            splice @u, $i, 1;
            # print "Removing $u->{min} - $u->{max}\n";
            $r->{max} = $u->{max};
            # print "Changing to $r->{min} - $r->{max}\n";
            last;
        }
    }

    # Add $r to @u
    push @u => $r;
    # print "Adding $r->{min} - $r->{max}\n";
}

print "Unique ranges: ", 0+@u, "\n";


my ($m, $n) = sort { $a->{min} <=> $b->{min} } @u;
print "Lowest range: $m->{min} - $m->{max}\n";
print "Next range: $n->{min} - $n->{max}\n";
print "Lowest unblocked: ", $m->{max} + 1, "\n";

my $c = sum map { $_->{max} - $_->{min} + 1 } @u;
print "IPs in all ranges: $c\n";

my $b = 2**32 - $c;
print "Unblocked IPs: $b\n";
