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
    s/\d+\+\d+/($&)/g;
    1 while s/^(.*)(\d+)\+(\(.*)$/"$1($2 + " . post($3)/e;
    1 while s/^(.*\))\+(\d+)(.*)$/pre($1) . " + $2)$3"/e;
    1 while s/^(.*\))\+(\(.*)$/pre($1) . " + " . post($2)/e;

    my $v = eval($_);
    $s += $v;
    print "$e = $_ = $v\n";
}

print "Sum: $s\n";

sub post {
    my $s = shift;
    my @s = split '', $s;
    my $c = 0;
    for my $i (0..$#s) {
        $c++ if $s[$i] eq '(';
        $c-- if $s[$i] eq ')';
        if ($c == 0) {
            $s[$i] = '))';
            return join '', @s;
        }
    }
    die "Unbalanced post: $s\n";
}

sub pre {
    my $s = shift;
    my @s = split '', $s;
    my $c = 0;
    for my $i (reverse 0..$#s) {
        $c++ if $s[$i] eq ')';
        $c-- if $s[$i] eq '(';
        if ($c == 0) {
            $s[$i] = '((';
            return join '', @s;
        }
    }
    die "Unbalanced pre: $s\n";
}
