#!/usr/bin/perl

$p=1;map{$m[@m]=$m={}if/^M/;$m->{i}=[split/\D+/,$1]if/s: (.+)/;$m->{o}=$1 if/d (.+)/;$p*=$m->{t}=$1 if/by (.+)/;$m->{d}[1]=$1 if/tr.* (\d+)/;$m->{d}[0]=$1 if/fa.* (\d+)/}<>;while(++$r<=1e4){for(@m){while($i=shift@{$_->{i}}){$_->{c}++;$_->{o}=~s/old/\$i/;$i=eval"$i$_->{o}";$i%=$p;push@{$m[$_->{d}[$i%$_->{t}==0]]{i}},$i}}}($i,$j)=sort{$b<=>$a}map$_->{c},@m;print$i*$j