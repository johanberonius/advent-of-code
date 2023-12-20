#!/usr/bin/perl
use strict;
use List::Util qw(uniq);

my %w;
while (<>) {
    if (/(\w+)\{(.*?)\}/) {
        $w{$1} = [map {
            my ($v, $o, $n, $d) = /(?:(\w)([<>])(\d+):)?(\w+)/;

            [$v ? "\$$v$o$n" : 1, $v, $o, $n, $d]
        } split ',', $2];
    }
}

print "Workflows: : ", 0+keys %w, "\n";

for my $w (keys %w) {
    my $d = uniq map $_->[4], @{$w{$w}};
    if ($d == 1) {
        $w{$w} = [[1, undef, undef, undef, $w{$w}[0][4]]];
    }
}

my %r;
for my $w (keys %w) {
    for my $r (@{$w{$w}}) {
        my ($c, $v, $o, $n, $d) = @$r;

        if ($v) {
            push @{$r{$v}} => $n + ($o eq '<' ? -1 : 0);
            @{$r{$v}} = sort {$a <=> $b} uniq @{$r{$v}};
        }
    }
}


push @{$r{x}} => 4000;
push @{$r{m}} => 4000;
push @{$r{a}} => 4000;
push @{$r{s}} => 4000;

print "x ranges: ", 0+@{$r{x}}, "\n";
print "m ranges: ", 0+@{$r{m}}, "\n";
print "a ranges: ", 0+@{$r{a}}, "\n";
print "s ranges: ", 0+@{$r{s}}, "\n";
my $n = @{$r{x}} * @{$r{m}} * @{$r{a}} * @{$r{s}};
print "Combinations: $n\n";


my $i;

my $cx = 0;
my $x = 1;
for my $rx (@{$r{x}}) {
    my $lx = $rx - $x + 1;

    my $cm = 0;
    my $m = 1;
    for my $rm (@{$r{m}}) {
        my $lm = $rm - $m + 1;

        my $ca = 0;
        my $a = 1;
        for my $ra (@{$r{a}}) {
            my $la = $ra - $a + 1;

            my $cs = 0;
            my $s = 1;
            for my $rs (@{$r{s}}) {
                my $ls = $rs - $s + 1;

                # print "{x=$x-$rx,m=$m-$rm,a=$a-$ra,s=$s-$rs}: ";
                my $w = 'in';
                w: while ($w{$w}) {
                    # print "$w ";
                    for my $r (@{$w{$w}}) {
                        my ($c, $v, $o, $n, $d) = @$r;

                        if (eval($c)) {
                            $w = $d;
                            # print "-> ";
                            next w;
                        }
                    }
                }

                # print "$w\n";
                $i++;

                unless ($i % 10_000) {
                    printf "Progress: %3.2f%%\n", 100*$i/$n;
                }

                $cs += $ls if $w eq 'A';
                $s = $rs + 1;
            }


            $ca += $la * $cs;
            $a = $ra + 1;
        }

        $cm += $lm * $ca;
        $m = $rm + 1;
    }

    $cx += $lx * $cm;
    $x = $rx + 1;
}


print "Iterations: $i\n";
print "Sum: $cx\n";
