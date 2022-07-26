__author__ = "Bart Engels"
__date__ = "28-07-2022"
__version__ = "v1"


rule regroup:
    """
    Converters the UniRef (Suzek et al., 2007) abundance profiles to EC abundance profiles
    """
    input:
        pathway = "{dataset}/humantool_output_{name}",
        dataset = '{dataset}'
    threads: 16
    output: directory("{dataset}/regrouped_files_{name}/")
    run:
        import os
        options_list =  dataset
        tsv_samples = ['genefamilies', 'pathabundance', 'pathcoverage']
        os.system("mkdir "+ workDIR  + '/' + str(output))
        for files in tsv_samples:
            shell("humann_regroup_table --input " + workDIR + '/' + str(input.pathway) + "/interleaved_" +  input.dataset + "_" + str(files) + ".tsv" + " --output " + workDIR + "/" + str(output) + "/" + str(files) + input.dataset + ".tsv" + " --group uniref50_rxn" )

rule write_to_db:
        """
        Writes the data form regrouped files to database
        """
        input: "{dataset}/regrouped_files_{name}/"
        log: "{dataset}/write_log_{name}.log"
        output: "{dataset}/write_log_{name}.log"
        run:
            from scripts.connect_to_database import DbConnector
            import os
            os.system("rm -f " +  str(input) +"/.snakemake_timestamp")
            for i in os.listdir(str(input)):
                print(str(input) + "/" + str(i))
                print(str(input) + "/" + str(i), int(research_index) , int(user_intials_index))
                DbConnector(str(input) + "/" + str(i), int(research_index) , int(user_intials_index)).write_to_dump_table()


