from collections import Counter
from typing import List, Union
from random import seed, choice
from requests.exceptions import ConnectionError
import re
import requests
from heapq import nlargest





PATH_TO_NAMES = "names.txt"
PATH_TO_SURNAMES = "last_names.txt"
PATH_TO_OUTPUT = "sorted_names_and_surnames.txt"
PATH_TO_TEXT = "random_text.txt"
PATH_TO_STOP_WORDS = "stop_words.txt"


def task_1():
    seed(1)
    names = open(PATH_TO_NAMES, 'r')
    names_list = names.read()
    names_list = names_list.lower()
    names_list = names_list.split()
    names_list = sorted(names_list)
    last_names = open(PATH_TO_SURNAMES, 'r')
    last_names_list = last_names.read()
    last_names_list = last_names_list.split()
    new_file = []
    name_surname = []
    for item in names_list:
        name_surname.append(item)
        name_surname.append(choice(last_names_list))
        new_file.append(name_surname)
        name_surname = []
    new_file = [' '.join(map(str, sub_list)) for sub_list in new_file]
    new_file = '\n'.join(new_file)
    sorted_names_and_surnames = open(PATH_TO_OUTPUT, 'w')
    with open(PATH_TO_OUTPUT, 'w') as file:
        file.write(new_file)
    names.close()
    last_names.close()
    sorted_names_and_surnames.close()


def task_2(top_k: int):
    text_file = open(PATH_TO_TEXT, 'r+', encoding='utf-8-sig')
    stop_words = open(PATH_TO_STOP_WORDS, 'r+', encoding='utf-8-sig')
    opened_text=str(text_file.read())
    opened_text=re.sub(r'[^A-Za-z]',' ', opened_text).lower()
    opened_text=opened_text.split()
    opened_stop_words=stop_words.read().split()
    resulting_list=[]
    for item in range(0, len(opened_text)):
        if opened_text[item] not in opened_stop_words:
            resulting_list.append(opened_text[item])
    for item in range(len(resulting_list)):
        print(resulting_list[item])
    count = Counter(resulting_list)
    return(count.most_common(top_k))




def task_3(url: str):
    response = requests.get(url)
    if response.status_code==200:
        return(response)
    else:
        response.raise_for_status()
task_3("https://github.com")


def task_4(data: List[Union[int, str, float]]):
    total_sum = 0
    for item in data:
        if type(item) is int or type(item) is float:
            total_sum += item
        else:
            try:
                total_sum += int(item)
            except:
                try:
                    total_sum += float(item)
                except ValueError:
                    print("Entered value is wrong")
                    break
    return total_sum


def task_5():
    try:
        number1, number2 = input().split()
        print(float(number1) / float(number2))
    except ZeroDivisionError:
        print("Can't divide by zero")
    except ValueError:
        print("Entered value is wrong")
