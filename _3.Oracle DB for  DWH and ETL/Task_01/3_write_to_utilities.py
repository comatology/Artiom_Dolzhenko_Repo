import json
import avro.schema
from avro.io import DatumWriter
from avro.datafile import DataFileWriter
import yaml
from datetime import datetime
import logging
import sqlite3
import pandas as pd
import pandavro as pdx
# pyarrow lib should be installed for exporting into parquet
import pyarrow


def read_pd_from_sqlite_db(db_path):
    """
           Function to write sqlite table information into the pandas dataframe
                 :param db_path: sqlite database path
                 :return: pandas dataframe with table data
             """
    cnx = sqlite3.connect(db_path)

    df = pd.read_sql_query("SELECT * FROM t_ordered_items", cnx)

    return df


def prepare_dict_for_avro_export(df_necessary, table_name):
    """
           Function to create dictionary with array of column dictionaries from dataframe
                 :param df_necessary: pandas dataframe with table data
                 :param table_name: table for which dictionary with column value should be generated
                 :return: dictionary with table information in format { table_name: [[{column1:value1,..columnN:valueN}..{column1N:value1N,..columnNN:valueNN}]]}
             """

    arr = []
    dicttable = {}
    dflen = df_necessary.shape[0]
    arrcolumnprop = []
    for i in range(dflen):
        table_row = df_necessary.iloc[i]
        dict_row = {}
        dict_row["ordered_items_surr_id"] = table_row['ORDERED_ITEMS_SURR_ID']
        dict_row["column1_int"] = table_row['COLUMN1_INT']
        dict_row["column2_int"] = table_row['COLUMN2_INT']
        dict_row["column3_int"] = table_row['COLUMN3_INT']
        dict_row["column4_int"] = table_row['COLUMN4_INT']
        dict_row["column5_int"] = table_row['COLUMN5_INT']
        dict_row["column6_int"] = table_row['COLUMN6_INT']
        dict_row["column7_int"] = table_row['COLUMN7_INT']
        dict_row["column8_int"] = table_row['COLUMN8_INT']
        dict_row["column9_int"] = table_row['COLUMN9_INT']
        dict_row["column10_int"] = table_row['COLUMN10_INT']
        dict_row["member"] = str(table_row['MEMBER'])
        dict_row["insert_date"] = str(table_row['INSERT_DATE'])

        arrcolumnprop.append(dict_row)

    if dicttable.get(table_name, "empty") == "empty":
        arr.append(arrcolumnprop)
        dicttable[table_name] = arr
    else:
        arr = dicttable.get(table_name, [])
        resulting_list = list(arr)
        resulting_list.append(arrcolumnprop)
        dicttable[table_name] = resulting_list

    LOGGER.info(
        "Dictionary with table {tablename} information was generated".format(tablename=table_name))
    return dicttable


def write_json_to_avcs_file(ordered_numbers_df, table_name):
    """
         method to write json into the AVRO schema file
         :param ordered_numbers_df: input dataframe which could be used schema generating
         :return: new *.avsc files with JSON
         """

    arr_with_json = []
    dictavro = {}
    ##print (ordered_numbers_df)
    ###  Task 3.1 Please instead of using Hardcoded Columns use Pandas Dataframe to get  ordered_numbers_df this data from there

    list_column_names=ordered_numbers_df.columns.to_list()
    list_column_types=ordered_numbers_df.dtypes.to_list()
    fields=[]

    for i in range(len(list_column_names)):
        type=''
        if str(list_column_types[i])=='int64':
            type='int'
        else:
            type='string'
        fields.append(({'name': list_column_names[i].lower(), 'type': type}))
    dictavro["type"] = "record"
    dictavro["namespace"] = table_name + ".avro"
    dictavro["name"] = table_name.lower()
    dictavro["fields"] = fields

    arr_with_json.append(json.dumps(dictavro))

    for list in arr_with_json:
        js = json.loads(list)
        table_name = js["name"]
        avsc_path = table_name.lower() + ".avsc"
        with open(avsc_path, "w") as f:
            json.dump(js, f)

    LOGGER.info(
        "New file with avro schema {avro_schema} was generated".format(avro_schema=avsc_path))

def write_dataframe_to_json(ordered_numbers_df, json_file_name):
    """
         method to write dataframe information into the json format
         :param config_df: pandas dataframe with configuration
         :param json_file_name: output json file name
         :return: new json file will be created
         """

    ###  Task 3.2 Please export dataframe into JSON file ( example you could see in folder )
    json.dumps({})
    print(json_file_name)
    ordered_numbers_df.to_json(orient='table')
    with open(json_file_name, "w") as f:
        f.write(ordered_numbers_df.to_json(orient='table'))




def write_dict_to_avro(file_name, avro_file_extension, dict_in, row_cnt, header_arr):
    """
         method to write down dictionary information into the avro file
         :param file_name: name of the AVRO file for the insertion
         :param avro_file_extension: extension of the output AVRO file
         :param: dict_in: dictionary with generated info which for insertion into AVRO file
         :param: row_cnt: count of the rows in the output AVRO file
         :param: header_arr: array with column headers
         :return: *.avro file in the provided directory
         """
    schema_name = file_name + ".avsc"
    LOGGER.info(
        "Load the avro schema to validate and serialize data from file {schema_file}".format(schema_file=schema_name))

    schema = avro.schema.Parse(open(schema_name, "rb").read())
    avro_name = file_name + avro_file_extension
    LOGGER.info(
        "Open avro file {file} using a avro container class, providing the schema to use and the {compression} compression to use".format(
            file=avro_name, compression='deflate'))

    with open(avro_name, "wb") as af:
        writer_deflate = DataFileWriter(af, DatumWriter(), schema, codec='deflate')

        hlen = len(header_arr)
        for j in range(row_cnt):
            dict = {}
            for k in range(hlen):
                dict[str(header_arr[k]).lower()] = dict_in[header_arr[k]][j]

            writer_deflate.append(dict)

        LOGGER.info(
            "Close the avro container with {rows} table rows inserted".format(rows=row_cnt))
        writer_deflate.close()


if __name__ == "__main__":
    start_dt = datetime.now()

    LOG_FILE_PATH = "log_file_3.txt"

    logging.basicConfig(filename=LOG_FILE_PATH,
                        format='%(asctime)s %(message)s',
                        filemode='w')

    LOGGER = logging.getLogger("Module2_Topic1")
    LOGGER.setLevel(logging.DEBUG)
    LOGGER.info("Start of the Module2_Topic1 read db file and export data into different file formats")

    with open('config.yaml', 'r') as stream:
        data_loaded = yaml.safe_load(stream)
        database_name = data_loaded.get('db_name')
        table_name = data_loaded.get('table_name')
        out_json_file_name = data_loaded.get('json_file')
        out_avro_opt1_file_name = data_loaded.get('avro_file_1')
        out_avro_opt2_file_name = data_loaded.get('avro_file_2')
        out_excel_file = data_loaded.get('excel_file')
        out_parquet_gzipped_file = data_loaded.get('parquet_gz_file')
        out_parquet_file = data_loaded.get('parquet_file')
    LOGGER.info("Input database file {file}".format(file=database_name))
    input_dataframe = read_pd_from_sqlite_db(database_name)




    ###  Task 3.3 Please leave in input dataframe only rows with all values > 20 and use this dataframe for exporting
    n_df = input_dataframe.select_dtypes(include=['float64', 'int64']) ##only numeric columns
    list_of_columns = n_df.columns.tolist() ##get list of columns
    query_text = ''
    for i in range(len(list_of_columns)):##create query text
        if i == len(list_of_columns) - 1:
            query_text = query_text + list_of_columns[i] + '>20'
        else:
            query_text = query_text + list_of_columns[i] + '>20 and '
    df1 = n_df.query(query_text)##run query


    ######################## JSON FILE ##################################
    LOGGER.info("Start to write dataframe with {rows} rows into the {file} json ".format(rows=input_dataframe.shape[0],
                                                                                         file=out_json_file_name))
    write_dataframe_to_json(input_dataframe, out_json_file_name)

    ######################## AVRO FILEs ##################################
    LOGGER.info("Export avro schema into json {file} ".format(file=table_name + '.avsc'))
    write_json_to_avcs_file(input_dataframe, table_name )

    LOGGER.info(
        "1st option to create avro file using special lib and convert dataframe directly to avro --> file {file} ".format(
            file=out_avro_opt1_file_name))
    pdx.to_avro(out_avro_opt1_file_name, input_dataframe)

    LOGGER.info(
        "Prepare special dictionary to converting data to AVRO")
    dict_df = input_dataframe.to_dict(orient='list')

    LOGGER.info(
        "2st option to create avro file using prepared dictionary and convert dictionary to avro --> file {file} ".format(
            file=out_avro_opt2_file_name))
    write_dict_to_avro(table_name, '_2.avro', dict_df, input_dataframe.shape[0], list(input_dataframe))

    ######################## Another kind of dictionary ##################################

    dict_table = prepare_dict_for_avro_export(input_dataframe, table_name)
    LOGGER.info(
        "Convert dataframe to dictionary just to see different dict options")
    LOGGER.info(
        "Output dictionary: {dict}".format(dict=str(dict_table)))

    ######################## Excel FILEs ##################################

    LOGGER.info(
        "Export table information into the Excel file".format(file=out_excel_file))
    input_dataframe.to_excel(out_excel_file, index=False)

    ######################## Parquet FILEs ##################################

    LOGGER.info(
        "Export table information into the parquet file already gzipped".format(file=out_parquet_gzipped_file))
    pd.io.parquet.get_engine('auto')
    input_dataframe.to_parquet(out_parquet_gzipped_file, compression='gzip')
    LOGGER.info(
        "Export table information into the parquet file ".format(file=out_parquet_file))
    input_dataframe.to_parquet(out_parquet_file)

    LOGGER.info(
        "Files in different formats were created in the current folder!")
