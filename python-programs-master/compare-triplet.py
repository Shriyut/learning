#https://www.hackerrank.com/challenges/compare-the-triplets/problem

def compareTriplets(a, b):
    al = len(a)
    bl = len(b)
    ac = 0
    bc = 0
    
    for i in range(0, al):
        if(a[i] > b[i]):
            ac+=1
        elif(b[i] > a[i]):
            bc+=1
    return(ac, bc)


if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    a = list(map(int, input().rstrip().split()))

    b = list(map(int, input().rstrip().split()))

    result = compareTriplets(a, b)

    fptr.write(' '.join(map(str, result)))
    fptr.write('\n')

    fptr.close()
