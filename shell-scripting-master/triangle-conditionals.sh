#https://www.hackerrank.com/challenges/bash-tutorials---more-on-conditionals/problem

read side1
read side2
read side3

if [[ "$side1" -ge 1 && "$side1" -le 1000 && "$side2" -ge 1 && "$side2" -le 1000 && "$side3" -ge 1 && "$side3" -le 1000 ]];
then
if [[ "$side1" = "$side2" && "$side2" = "$side3" ]];
then
    echo "EQUILATERAL"
elif [[ "$side1" = "$side2" && "$side2" != "$side3" ]];
then
    echo "ISOSCELES"
elif [[ "$side2" = "$side1" && "$side1" != "$side3" ]];
then
    echo "ISOSCELES"
elif [[ "$side3" = "$side1" && "$side1" != "$side2" ]];
then
    echo "ISOSCELES"
elif [[ "$side2" = "$side3" && "$side3" != "$side1" ]];
then
    echo "ISOSCELES"
elif [[ "$side1" != "$side2" && "$side1" != "$side3" && "$side2" != "$side3" ]];
then
    echo "SCALENE"
fi
fi
