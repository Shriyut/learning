#https://www.hackerrank.com/challenges/30-exceptions-string-to-integer/problem

#!/bin/python3

import sys


S = input().strip()

try:
    i = int(S)
    print(i)
except ValueError:
    print("Bad String")
