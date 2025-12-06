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
    print "Checking $r->{min} - $r->{max}\n";

    # Skip $r if any range in @u covers it
    if (any { $_->{min} <= $r->{min} && $r->{max} <= $_->{max} } @u) {
        print "Skip $r->{min} - $r->{max}\n";
        next;
    }

    # Remove any ranges in @u that are covered by $r
    @u = grep { not $r->{min} <= $_->{min} && $_->{max} <= $r->{max} } @u;

    # If any range in @u includes $r->{min}, remove it from @u and change $r->{min} to $u->{min}
    for my $i (0..$#u) {
        my $u = $u[$i];
        if ($u->{min} <= $r->{min} && $r->{min} <= $u->{max}) {
            splice @u, $i, 1;
            print "Removing $u->{min} - $u->{max}\n";
            $r->{min} = $u->{min};
            print "Changing to $r->{min} - $r->{max}\n";
            last;
        }
    }

    # If any range in @u includes $r->{max}, remove it from @u and change $r->{max} to $u->{max}
    for my $i (0..$#u) {
        my $u = $u[$i];
        if ($u->{min} <= $r->{max} && $r->{max} <= $u->{max}) {
            splice @u, $i, 1;
            print "Removing $u->{min} - $u->{max}\n";
            $r->{max} = $u->{max};
            print "Changing to $r->{min} - $r->{max}\n";
            last;
        }
    }

    # Add $r to @u
    push @u => $r;
    print "Adding $r->{min} - $r->{max}\n";
    print "Current ranges\n";
    for my $u (@u) {
        print "Range $u->{min} - $u->{max}\n";
    }
    print "\n";
}

for my $u (@u) {
    print "Range $u->{min} - $u->{max}\n";
}

for my $u (@u) {
    for my $v (@u) {
        next if $u == $v;
        if ($v->{min} <= $u->{min} && $u->{min} <= $v->{max} or
            $v->{min} <= $u->{max} && $u->{max} <= $v->{max}) {
            print "Overlap $u->{min} - $u->{max} and $v->{min} - $v->{max}\n";
        }
    }
}

for my $u (@u) {
    for my $v (@u) {
        next if $u == $v;
        if ($v->{min} <= $u->{min} && $u->{max} <= $v->{max}) {
            print "Range $u->{min} - $u->{max} contained in $v->{min} - $v->{max}\n";
        }
    }
}

my $c = sum map { $_->{max} - $_->{min} + 1 } @u;
print "IDs in all ranges: $c\n";
