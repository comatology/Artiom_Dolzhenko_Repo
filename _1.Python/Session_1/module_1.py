from numbers import Number
from typing import List, Tuple, Any


#Write a Python function task_1 to find those numbers which are divisible by 3 and multiple of 5, between 1 and 1000 (both included).
#Return list of correct numbers.
def task_1():
    numbers=[]
# n is for number %3 & %5
    for number in range(1, 1001):
        if (number % 3 == 0) and (number % 5 == 0):
            numbers.append(number)
    return numbers



#Write a Python function task_2 that accepts a string and calculate the number(integers) of digits and letters(english). Return num of digits and num of letters.
def task_2(string):
    number_integers = 0
    number_letters = 0
# checking the conditions in loop using ancii values
    for syllable in string:
        if ord(syllable)>=48 and ord(syllable)<=57:
            number_integers += 1
        elif (ord(syllable)>=65 and ord(syllable)<=90) or (ord(syllable)>=97 and ord(syllable)<=122):
            number_letters += 1
    return((number_integers,number_letters))



#Write a Python function task_3 to compute the difference between two lists. Each list consists of unique values!
#Return tuple of differences.
def task_3(list1, list2):
    difference1 = []
    difference2=[]
# checking in loop values and add to answer differ values
    for item in list1:
        if item not in list2:
            difference1.append(item)
    for item in list2:
        if item not in list1:
            difference2.append(item)

    return((difference1,difference2))



#Write a Python function task_4 to convert a list of multiple integers(non-negative) into a single integer.
def task_4(list_of_integers) -> int:
    str_val = [str(i) for i in list_of_integers]
    single_integer = int("".join(str_val))
    return (single_integer)



#Write a Python function task_5 to ff lists whose sum of elements is the highest.
#If the nested lists have the same max sum, then you need to return first of them.
#Return this list.
def task_5(list_of_lists) -> List:
    max_list=[]
    sum_list=[]
#sum of values from list
    for i in list_of_lists:
        sum_list.append(sum(i))
#select list with max sum using indexes
    max_list=list_of_lists[(sum_list.index(max(sum_list)))]
    return max_list



#Write a Python function task_6 to reverse integer without usage of converting to str.
def task_6 (num):
    last_digit = 0 # for the last digit in the integer
    newnum = 0 # for the new integer
    flag = True # flag for marking negative int
    if num < 0:
        flag = False
    num = abs(num) # make int positive
    #  take the last digit of the number and discard it until there are digits in the number
    while num != 0 :
        last_digit = num % 10
        newnum = newnum*10 + last_digit # forming new integer
        num = num // 10
    if flag == False:
        newnum *= -1 # if num was negative at the beginning, make newnum negative too.
    return newnum


def task_7(str1):
        char_order = []
        counts = {}
        for c in str1:
            if c in counts:
                counts[c] += 1
            else:
                counts[c] = 1
                char_order.append(c)
        for c in char_order:
            if counts[c] == 1:
                return c
        return None
