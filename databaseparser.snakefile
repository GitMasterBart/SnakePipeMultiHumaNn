rule write_to_db:
        input: "{dataset}/humantool_output_{name}"
        log: "{dataset}/write_log_{name}.log"
        output: "{dataset}/write_log_{name}.log"
        run:
            from biobakery.appModels.SnakePipeMultiHumaNn.scripts.connect_to_database import DbConnector
            from biobakery.appModels.file_scraper import FileScraper
            import os
            for i in os.listdir(str(input)):
                print(str(input) + "/" + str(i))
                inner_files = FileScraper(str(input))
                inner_files.find_files_in_directories()
                filelist = inner_files.get_fileset()
                if ".snakemake_timestamp" in filelist:
                    os.system("rm -f " +  str(input) +"/.snakemake_timestamp")
                DbConnector(str(input) + "/" + str(i), int(research_index) , int(user_intials_index)).write_to_dump_table()
