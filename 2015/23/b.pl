#!/usr/bin/perl
use strict;

my @i;
while (<>) {
    my @l = /(\w+) (\w)?(?:, )?([+-]\d+)?/ or die $_;
    push @i => \@l;
}

my %r = (a => 1, b => 0);
my $c = 0;
my $pc = 0;
while (1) {
    my $l = $i[$pc] or last;
    my ($i, $r, $o) = @$l;
    $c++;

    if ($i eq 'hlf') {
        $r{$r} /= 2;
    } elsif ($i eq 'tpl') {
        $r{$r} *= 3;
    } elsif ($i eq 'inc') {
        $r{$r}++;
    } elsif ($i eq 'jmp') {
        $pc += $o;
        next;
    } elsif ($i eq 'jie') {
        if ($r{$r} % 2 == 0) {
            $pc += $o;
            next;
        }
    } elsif ($i eq 'jio') {
        if ($r{$r} == 1) {
            $pc += $o;
            next;
        }
    } else {
        die $i;
    }

    $pc++;
}

print "Iterations: $c\n";
print "a: $r{a}, b: $r{b}\n";
