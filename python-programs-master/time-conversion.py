#https://www.hackerrank.com/challenges/time-conversion/problem

#!/bin/python3

import os
import sys

#
# Complete the timeConversion function below.
#
def timeConversion(s):
    #
    # Write your code here.
    #
    str1 = s[-2:]
    if ( s == "12:00:00PM"):
        strr = "12:00:00"
        return strr
    if ( s == "12:00:00AM"):
        stra = "00:00:00"
        return stra
    if (str1 == "AM" and s!= "12:00:00AM"):
        str2 = s[0:len(s)-2]
        if (s[0:2] == "12"):
            str3 = str2[3:len(s)-2]
            str2 = "00:"+str3

        return str2
    elif (str1 == "PM" and s != "12:00:00PM"):
        str3 = s[3:len(s)-2]
        str4 = s[0:2]
        if ( str4 != "12"):
            hh = int(str4)
            hh = hh+12
            str5 = str(hh)+":"+str3
        else:
            str5 = "12:"+str3
        return str5


if __name__ == '__main__':
    f = open(os.environ['OUTPUT_PATH'], 'w')

    s = input()

    result = timeConversion(s)

    f.write(result + '\n')

    f.close()
