#https://www.hackerrank.com/challenges/electronics-shop/problem

#!/bin/python3

import os
import sys

#
# Complete the getMoneySpent function below.
#
def getMoneySpent(keyboards, drives, b):
    #
    # Write your code here.
    #
    sp = []
    for i in range(0, len(keyboards)):
        for j in range(0, len(drives)):
            if (keyboards[i]+drives[j] <= b):
                sp.append(keyboards[i]+drives[j])
    
    if (len(sp) == 0):
        return -1
    else:
        return max(sp)


if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    bnm = input().split()

    b = int(bnm[0])

    n = int(bnm[1])

    m = int(bnm[2])

    keyboards = list(map(int, input().rstrip().split()))

    drives = list(map(int, input().rstrip().split()))

    #
    # The maximum amount of money she can spend on a keyboard and USB drive, or -1 if she can't purchase both items
    #

    moneySpent = getMoneySpent(keyboards, drives, b)

    fptr.write(str(moneySpent) + '\n')

    fptr.close()
