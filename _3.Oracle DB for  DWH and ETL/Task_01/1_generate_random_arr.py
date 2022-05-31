import argparse
from datetime import datetime
import queue
import random
import csv
from threading import Thread
import logging


def gen_random_dict(column_count: int) -> dict:
    """
           Function generate dictionary with random numbers
                 :param column_count: count of columns for which numbers should be generated
                 :return: dictionary with random numbers in format { Column1 : 2, Column2 : 3, ..... ColumnN : 4 }
             """
    dict = {}
    for i in range(column_count):
        dict[f"COLUMN{i + 1}"] = random.randint(1, 100)

    return dict


def write_dict_to_csv_file(file_path: str, arr_dict_tofile: list) -> None:
    """
           Function to write dictionary to csv file
                 :param file_path: target csv file
                 :param arr_dict_tofile: array with values for exporting [{ Column1 : 2, Column2 : 3, ..... ColumnN : 4 }, { Column1 : 15, ... ColumnN : 47 }....]
                 :param headerRow: count of columns for which numbers should be generated
                 :return: information are written to the csv file
             """

    ### TASK 1.1 Here you was provided headerRow as a parameter, but it easily could be retrieved from the array arr_dict_tofile itself
    headerRow= list(arr_dict_tofile[0].keys()) ## get the header

    with open(file_path, "w", newline='') as csvf:

        if len(headerRow) > 0:
            fieldnames = headerRow
        else:
            fieldnames = []

        arrwriter = csv.DictWriter(csvf, fieldnames=fieldnames)
        arrwriter.writeheader()
        arrwriter.writerows(arr_dict_tofile)


def read_dict_arr_from_file(file_path: str, arr_number: int) -> dict:
    """
          Function to read dictionary with arrays from csv file
                :param file_path: path to source csv file
                :param arr_number: column of the array which should be returned as a dictionary
                :return: output dictionary in format {Column1:[1,2,3,4....]....ColumnN:[3,5,6...]}
            """
    with open(file_path, "r", newline='') as csvin:
        fl = csv.reader(csvin, delimiter=',')
        header = next(fl)
        ### Dict Comprehension in Python
        out_dict = {header[arr_number]: [int(line[arr_number]) for line in fl]}

    return out_dict


def buble_sorting(arr: list) -> list:
    """
          Function to sort number with bubble algorithm
                :param arr: array to be sorted
                :return: array with sorted numbers
            """
    ### TASK 1.2 Please insert bubble sorting algorithm here
    for i in range(len(arr)):
        for j in range(len(arr) - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]

    return arr


def worker_thread(inqueue: queue.Queue, outarr: list) -> None:
    """
          Function to order each column separately in the independent threads
                :param inqueue: queue with columns to be ordered
                :param outarr: output sorted array
                :return: array with sorted numbers
            """

    while not inqueue.empty():

        item = inqueue.get()
        if item is None:
            break

        for (col, arraytosort) in item.items():
            item[col] = buble_sorting(arraytosort)

        lenarr = len(arraytosort)
        for i in range(lenarr):
            dict = outarr[i]
            dict[col] = arraytosort[i]
            outarr[i] = dict

        inqueue.task_done()


if __name__ == "__main__":

    start_dt = datetime.now()

    LOG_FILE_PATH = "log_file_1.txt"

    logging.basicConfig(filename=LOG_FILE_PATH,
                        format='%(asctime)s %(message)s',
                        filemode='w')

    LOGGER = logging.getLogger("Module2_Topic1")
    LOGGER.setLevel(logging.DEBUG)
    LOGGER.info("Start of the Module2_Topic1 generate random numbers and export to file")

    t3parser = argparse.ArgumentParser(description='Please provide output file name for ordered values')

    t3parser.add_argument("-file_name", "--name", help="File name in the working directory", default="ordered_file.csv")
    t3parser.add_argument("-row_count", "--rows", type=int, help="Rows count in file", default=1000)
    t3parser.add_argument("-column_count", "--columns", type=int, help="Columns count in file", default=10)

    args = t3parser.parse_args()

    file_name = args.name
    arr_column_count = args.columns
    arr_row_count = args.rows

    LOGGER.info("Output file name {file} with {columns} columns and rows {rows}".format(file=file_name,
                                                                                        columns=arr_column_count,
                                                                                        rows=arr_row_count))

    worker_threads_cnt = 4
    LOGGER.info("We will run script in {threads} threads".format(threads=worker_threads_cnt))
    input_csv_file = "dictionary_source.csv"
    LOGGER.info("File with unsorted numbers {file}".format(file=input_csv_file))
    header_row = []
    list_dict = []

    LOGGER.info("Start to prepare {column_cnt} headers for exporting into the file".format(column_cnt=arr_column_count))
    for i in range(arr_column_count):
        header_row.append('COLUMN' + str(i + 1))

    LOGGER.info("Start to prepare array with dict [{ Column1 : 2, Column2 : 3, ..... ColumnN : 4 }] ")
    for j in range(arr_row_count):
        list_dict.append(gen_random_dict(arr_column_count))

    LOGGER.info("Export dictionary with unsorted numbers to file {file_name}".format(file_name=input_csv_file))
    write_dict_to_csv_file(input_csv_file, list_dict)

    qfifo = queue.Queue()

    LOGGER.info("Populate {column_cnt} queue members with dictionaries for sorting".format(column_cnt=arr_column_count))
    for k in range(arr_column_count):
        qfifo.put(read_dict_arr_from_file(input_csv_file, k))

    threads = []
    sorted_arr = []

    for i in list_dict:
        sorted_arr.append(dict())

    LOGGER.info("Processing each sorting in the separate Thread to spead up the process".format(column_cnt=arr_column_count))
    LOGGER.info("We invoke {threads_cnt} threads in our logic to work with queue members".format(threads_cnt=worker_threads_cnt))
    for i in range(worker_threads_cnt):
        thrd = Thread(target=worker_thread, name="ChildThread" + str(i), args=(qfifo, sorted_arr,))
        thrd.setDaemon(True)
        thrd.start()
        threads.append(thrd)

    for j in threads:
        j.join()

    LOGGER.info("Export dictionary with sorted numbers to file {file_name}".format(file_name=file_name))
    write_dict_to_csv_file(file_name, sorted_arr)

    sdiff_time = datetime.now() - start_dt

    LOGGER.info("Script runtime is {time}".format(time=sdiff_time))
