from collections import defaultdict as dd
from itertools import product
from typing import Dict, Any, Tuple, List



def task_1(dict_1, dict_2):
    for key in dict_2:
        if key in dict_1:
            dict_2[key] = dict_2[key] + dict_1[key]
    c = {**dict_1, **dict_2}
    return c



def task_2():
    result = dict()
    for key in range(1, 16):
        result[key] = key ** 2
    return(result)


def task_3(data: Dict[Any, List[str]]):
    combinations = []
    for item in product(*data.values()):
        output = ''
        for letter in item:
            output = output + letter
        combinations.append(output)
    return(combinations)


def task_4(data: Dict[str, int]):
    new_list = []
    counter = 0
    new_dict = dict(sorted(data.items(), key=lambda item: item[1], reverse=True))
    for key in new_dict.keys():
        new_list.append(key)
        counter += 1
        if counter == 3:
            break
    return new_list



#def task_5(data: List[Tuple[Any, Any]]) -> Dict[str, List[int]]:
def task_5(list)-> Dict:
    """"
    k - key
    v - value
    """
    result = {}
    for k, v in list:
     result.setdefault(k, []).append(v)
    return result


def task_6(the_list):
    the_list = list(dict.fromkeys(the_list))
    return the_list

def task_7(words: [List[str]]) -> str:
    pass


def task_8(haystack: str, needle: str) -> int:
    pass
