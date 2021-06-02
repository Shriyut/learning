ps -ef | grep -i python3
ps -ef | grep -i python3 | awk {'print $2'} >/tmp/process
ls -ls /tmp/process
cat /tmp/process | wc -l
for i in `cat /tmp/processes`
do 
  kill -9 $i
done
ps -ef | grep -i python3  
