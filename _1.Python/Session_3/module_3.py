import time
from typing import List


Matrix = List[List[int]]


def task_1(exp: int):
# closure func to raise exp in power of itself
    def from_task_1(value):
        return value ** exp
    return from_task_1


def task_2(*args, **kwags):
    for i in range(len(args)):
        print(args[i])
    for value in kwags.values():
        print(value)


def helper(func):
    def wrapper(name):
        print('Hi, friend! What\'s your name?')
        line = func(name)
        print('See you soon!')
        return line
    return wrapper


@helper
def task_3(name: str):
    print(f"Hello! My name is {name}.")


def timer(func):
    def wrapper():
        start_time = time.time()
        func()
        end_time = time.time()
        run_time = end_time - start_time
        print(f"Finished {func.__name__} in {run_time:.4f} secs")
    return wrapper


@timer
def task_4():
    return len([1 for _ in range(0, 10 ** 8)])



def task_5(matrix: Matrix) -> Matrix:
    matrix_resurrection = []
    for values in zip(*matrix):
        matrix_resurrection.append(list(values))
    return matrix_resurrection




def task_6(queue: str):
    pass

