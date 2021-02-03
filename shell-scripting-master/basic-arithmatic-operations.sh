#https://www.hackerrank.com/challenges/bash-tutorials---the-world-of-numbers/problem

read num1
read num2

if [[ "$num1" -ge -100 && "$num1" -le 100 && "$num2" -ge -100 && "$num2" -le 100 ]];
then
#bc is used to handle floating point numbers
((sum =`expr "$num1 + $num2" | bc`))
((dif =`expr "$num1 - $num2" | bc`))
((mul =`expr "$num1 * $num2" | bc`))
#((div =`expr "$num1 / $num2" | bc -l`)) 
((div =`expr "$num1 / $num2"` ))
# -l option loads the standard math library with default scale set to 20
echo "$sum"
echo "$dif"
echo "$mul"
echo "$div"
fi
