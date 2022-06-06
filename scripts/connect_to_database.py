#!/env/bin/python3
import sys
import mysql.connector
from mysql.connector import Error
import pandas as pd
import pandas.errors

class DbConnector:
    def __init__(self, file, r_id, u_id):
        self.file = file
        self.r_id = r_id
        self.u_id = u_id

    try:

        def write_to_dump_table(self):
            connection = mysql.connector.connect(host='localhost',
                                                      database='biobakery',
                                                      user='root',
                                                      password='rakker444')
            cursor = connection.cursor()
            cursor.execute("show tables;")
            myresult = cursor.fetchall()
            first_column_object = str(pd.read_table(self.file).columns.tolist()[0])
            transformed_table = pd.DataFrame(pd.melt(pd.read_table(
                self.file,
                lineterminator='\n'), id_vars=first_column_object))
            print(transformed_table)
            sql = "INSERT INTO biobakery_dumptable (gene, family, sample, result, researches_id_id, user_id_id) VALUES (%s,%s,%s,%s,%s,%s) "
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
                # print((gene, family, sample, result, self.r_id, self.u_id))


                compleet_list.append((gene,family,sample,result, self.r_id, self.u_id))

            cursor.executemany(sql,compleet_list)
            connection.commit()
            # print(range(len(transformed_table)))



    except (Error, pandas.errors.Rule) :
        print("Error while connecting to MySQL")

def main():
    DbConnector("/Users/bengels/Desktop/Uploaded_files/demofiles_wetsusR1R2_v1/humantool_output_map_name/interleaved_map_name_genefamilies.tsv", 9, 1).write_to_dump_table()



if __name__ == '__main__':
    main()

