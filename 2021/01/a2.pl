# 44 chars
# @n=<>;$i+=$n[$_]<$n[$_+1]for 0..@n-2;print$i

# 32 chars
map{$i+=$p<$_;$p=$_}<>;print$i-1
