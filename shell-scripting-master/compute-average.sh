#https://www.hackerrank.com/challenges/bash-tutorials---compute-the-average/problem

read n

for ((i=0;i<$n;i++));
do
    read num
    sum=$((sum+num))
done

result=$(echo "$sum/$n" | bc -l)

printf "%.3f" "$result"
