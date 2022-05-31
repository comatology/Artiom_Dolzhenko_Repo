import datetime

import cx_Oracle
import config as cfg


def run_procedure(procedure_name, start_dt=0, end_dt=0):

    try:
        with cx_Oracle.connect(cfg.username,
                               cfg.password,
                               cfg.dsn,
                               encoding=cfg.encoding) as connection:
            # create a new cursor
            with connection.cursor() as cursor:
                # call the stored procedure
                if start_dt==0 or end_dt==0:
                    cursor.callproc(procedure_name)
                else:
                    cursor.callproc(procedure_name, [start_dt, end_dt])
                return procedure_name +' done'
    except cx_Oracle.Error as error:
        print(error)

if __name__ == '__main__':
    print(run_procedure('PKG_LOAD_SRC_1_TABLES.PRC_LOAD_SRC_1_SALES'))
    print(run_procedure('PKG_LOAD_SRC_2_TABLES.PRC_LOAD_SRC_2_SALES'))
    print(run_procedure('PKG_LOAD_FCT_SALES.PRC_LOAD_CE_SALES',datetime.date(2021, 10, 1), datetime.date(2022, 1, 1)))
    print(run_procedure('PKG_LOAD_FCT_SALES.PRC_LOAD_FCT_SALES', datetime.date(2021, 10, 1), datetime.date(2022, 1, 1)))
