rule write_to_db:
        input: "{dataset}/humantool_output_{name}"
        log: "{dataset}/write_log_{name}.log"
        output: "{dataset}/write_log_{name}.log"
        run:
            from scripts.connect_to_database import DbConnector
            for i in os.listdir(str(input)):
                    DbConnector(str(input) + "/" + str(i), int(research_index) , int(user_intials_index)).write_to_dump_table()


