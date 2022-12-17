# 42 chars
@n=<>;$i+=$n[$_-3]<$n[$_]for 3..@n;print$i

# 44 chars
# map{$i+=$p<$_;$p=$q;$q=$l;$l=$_}<>;print$i-3
