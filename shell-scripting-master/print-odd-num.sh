#https://www.hackerrank.com/challenges/bash-tutorials---looping-and-skipping/problem

for i in {1..100}
do
((rem=$i%2))
if [ "$rem" != 0 ]
then
 echo $i
fi
done
