#!/usr/bin/perl
use strict;

my @e;
while (<>) {
    chomp;
    push @e => $_;
}

my $s = 0;
for (@e) {
    my $e = $_;
    s/\s+//g;

    my @o = ('+');
    my @v = (0);
    while ($_) {
        if (s/^(\d+)//) {
            $v[-1] = eval("$v[-1]$o[-1]$1");
        } elsif (s/^([+*])//) {
            $o[-1] = $1;

        } elsif (s/^\(//) {
            push @o => '+';
            push @v => 0;
        } elsif (s/^\)//) {
            pop @o;
            my $v = pop @v;
            $v[-1] = eval("$v[-1]$o[-1]$v");
        }
    }

    $s += $v[-1];
    print "$e = $v[-1]\n";
}

print "Sum: $s\n";
