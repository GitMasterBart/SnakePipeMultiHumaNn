#!/env/bin/python3

"""
This class pushes the result data in a database, it uses mysql.connector
to make contact with the mysql database. It is a class that needs three variables:
 file, r_id(research_id), u_id (user_id)"""

__author__ = "Bart Engels"
__date__ = "28-07-2022"
__version__ = "v1"

import mysql.connector
from mysql.connector import Error
import pandas as pd
import pandas.errors


class DbConnector:
    """
    Parsers a table and writes it to the database
    that is given in mysql.connector.connect
    add informtion yourself: host, database, user, password
    """
    def __init__(self, file, r_id, u_id):
        self.file = file
        self.r_id = r_id
        self.u_id = u_id

    try:
        def write_to_dump_table(self):
            connection = mysql.connector.connect(host='',
                                                      database='',
                                                      user='',
                                                      password='')
            cursor = connection.cursor()
            cursor.execute("show tables;")
            myresult = cursor.fetchall()
            first_column_object = str(pd.read_table(self.file).columns.tolist()[0])
            transformed_table = pd.DataFrame(pd.melt(pd.read_table(
                self.file,
                lineterminator='\n'), id_vars=first_column_object))
            sql = "INSERT INTO biobakery_dumptable (gene, family, sample, " \
                  "result, researches_id_id, user_id_id) VALUES (%s,%s,%s,%s,%s,%s) "
            family = ""
            compleet_list = []


            for i in range(len(transformed_table)):
                if ":" or "|" in str(transformed_table.values[i][0]):
                    gene = transformed_table.values[i][0].split(":")[0]
                    if len(transformed_table.values[i][0].split(":")) == 2:
                        family = transformed_table.values[i][0].split(":")[1]
                    elif "|" in transformed_table.values[i][0].split(":")[0]:
                        gene = str(transformed_table.values[i][0].split(":")[0]).split("|")[0]
                        family = str(transformed_table.values[i][0].split(":")[0]).split("|")[1]
                    else:
                        gene = transformed_table.values[i][0]
                        family = ""
                        # print([gene,family])
                        sample = str(transformed_table.values[i][1])
                        result = transformed_table.values[i][2]
                compleet_list.append((gene,family,sample,result, self.r_id, self.u_id))

            cursor.executemany(sql,compleet_list)
            connection.commit()
    except (Error, pandas.errors.Rule):
        print("Error while connecting to MySQL")
