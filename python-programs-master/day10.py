#https://www.hackerrank.com/challenges/30-binary-numbers/problem

#!/bin/python3

import math
import os
import random
import re
import sys



if __name__ == '__main__':
    n = int(input())
    count = []
    j = 0
    x = bin(n)
    z = x[2:]
    
    y = int(z)
    cv = 1
    for i in range(len(z)):
        
        if (z[i] == "1"):
            if ( (i+1) < len(z) and z[i+1] == "1"):
                cv = cv+1
                #print (cv)
                count.append(cv)
            elif ( (i+1) < len(z) and z[i+1] == "0"):
                count.append(cv)
        elif ( z[i] == "0"):
            #count[j] = cv
            #j = j+1
            
            cv = 1

    print (max(count))
    #print (count)
