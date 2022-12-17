#!/usr/bin/perl
use strict;
use List::Util qw(min);

my $army;
my %armies;
while (<>) {
    if (/\s*((\w|\s)+):/) {
        $army = $1;
    } elsif (my @match = /(\d+)\s+units.*?(\d+)\s+hit points.*?attack.*?(\d+)\s*(\w+)\s+damage.*initiative\s+(\d+)/) {
        my ($weak_to) = /weak to\s+(.*?)[;)]/;
        my ($immune_to) = /immune to\s+(.*?)[;)]/;
        push @{$armies{$army}} => {
            number => 1+@{$armies{$army}},
            army => $army,
            units => 0+$match[0],
            hit_points => 0+$match[1],
            immune_to => {map { $_ => 1 } split /\s*,\s*/, $immune_to},
            weak_to => {map { $_ => 1 } split /\s*,\s*/, $weak_to},
            attack_damage => 0+$match[2],
            damage_type => $match[3],
            initiative => 0+$match[4],
        };
    }
}

my @armies = keys %armies;
for my $i (0..@armies-1) {
    for my $group (@{$armies{$armies[$i]}}) {
        $group->{opponent} = $armies[!$i];
    }
}


# use Data::Dumper;
# print Dumper(\%armies);
# exit;


# army
#   |-- groups
#     |-- units

my $round = 1;

print "Army 0 has ", 0+@{$armies{$armies[0]}}, " groups\n";
print "Army 1 has ", 0+@{$armies{$armies[1]}}, " groups\n";

while (@{$armies{$armies[0]}} && @{$armies{$armies[1]}}) {

    print "Round $round\n";
    print "\n";

    for my $army (sort keys %armies) {
        print "$army:\n";

        for my $i (0..@{$armies{$army}}-1) {
            my $group = $armies{$army}[$i];
            print "Group $group->{number} contains $group->{units} units\n";
        }
    }

    print "\n";

    for my $group (map { @$_ } values %armies) {
        delete $group->{target};
        delete $group->{targeted_by};
    }

    # target selection phase
    #  each group in both armies
    group: for my $group (sort {
            # sort by decreasing effective power
            $b->{units} * $b->{attack_damage} <=> $a->{units} * $a->{attack_damage} or
            # or highest initiative
            $b->{initiative} <=> $a->{initiative}
        } map { @$_ } values %armies) {

        # each group in opposing army
        for my $target (sort {
                # sort by most damage
                group_damage($group, $b) <=> group_damage($group, $a) or
                # or effective power
                $b->{units} * $b->{attack_damage} <=> $a->{units} * $a->{attack_damage} or
                # or highest initiative
                $b->{initiative} <=> $a->{initiative}
            } @{$armies{$group->{opponent}}}) {

            my $damage = group_damage($group, $target);
            print "$group->{army} group $group->{number} would deal defending group $target->{number}: ", $damage, " damage";

            # exclude zero damage and already choosen
            if (!$damage or $target->{targeted_by}) {
                print ", not choosen\n";
                next;
            }

            # choose target
            print ", choosen\n";
            $group->{target} = $target;
            $target->{targeted_by} = $group;
            next group;
        }
    }

    print "\n";

    # attack phase
    #  each group in both armies
    for my $group (sort {
            # sort by decreasing initiative
            $b->{initiative} <=> $a->{initiative}
        } map { @$_ } values %armies) {
        unless ($group->{units} > 0) {
            print "$group->{army} group $group->{number} has been eliminated and can not attack\n";
            next;
        }
        my $target = $group->{target};
        if ($target) {
            my $damage = group_damage($group, $target);

            #    - units -= int(total damage / unit hit points)
            my $kills = min($target->{units}, int($damage / $target->{hit_points}));

            print "$group->{army} group $group->{number} attacks defending group $target->{number}, inflicting $damage $group->{damage_type} damage and killing $kills of $target->{units} units with $target->{hit_points} hit points each\n";
            $target->{units} -= $kills;

            if ($target->{units} <= 0) {
                $armies{$target->{army}} = [grep $_ ne $target, @{$armies{$target->{army}}}];
                print "Defending group $target->{number} is eliminated\n";
            }
        }

    }
    print "\n";

# last if $round >= 500;
    $round++;
}

print "Battle ended after $round rounds\n";
for my $army (sort keys %armies) {
    print "$army:\n";
    my $result = 0;
    for my $i (0..@{$armies{$army}}-1) {
        print "Group ", $i+1, " contains $armies{$army}[$i]{units} units\n";
        $result += $armies{$army}[$i]{units};
    }
    if ($result) {
        print "Total units left: $result\n";
    }
    unless (@{$armies{$army}}) {
        print "No groups remain.\n";
    }
}

# 25289 > result = 25088 > 25087

sub group_damage {
    my $group = shift;
    my $target = shift;
    #    - total damage = effective power =  units * damage
    my $damage = $group->{units} * $group->{attack_damage};
    #    - damage = 0 if immune
    $damage = 0 if $target->{immune_to}{$group->{damage_type}};
    #    - damage *= 2 if weak
    $damage *= 2 if $target->{weak_to}{$group->{damage_type}};
    return $damage;
}
