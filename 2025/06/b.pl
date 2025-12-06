#!/usr/bin/perl
use strict;

my @n;
while (<>) {
    chomp;
    my @i = map $_ eq ' ' ? '' : $_, split '';
    push @{$n[$_]} => $i[$_] for 0..@i;
}

my $s = 0;
my $o;
my $r;
my @d;
for (@n) {
    $o ||= pop @$_;
    my $d = join '', @$_;

    if ($d) {
        push @d => $d;
        $r = '';
        print "Number: $d\n";
    } else {
        my $e = join $o, @d;
        $r = eval $e;
        $s += $r;
        print "Expression: $e, result: $r\n";
        $o = '';
        @d = ();
    }

}

print "Sum: $s\n";
