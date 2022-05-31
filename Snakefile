import os

configfile: "config.yaml"


workDIR = config['inputfiles']
workdir: config['inputfiles']
SAMPLES = config["samples"]
NAME = config["name"]
dataset = config["dataset"]
trimmomatic = "--bypass-trim"
fastqc_start = " "
fastqc_end = " "
bypass_trf = "--bypass-trf"
database = " "

remove_temp_output = " "
verbose = " "
bypass_n_search = " "
nucleotide_db =" "
protein_database = ""
## variables
try:
    database = "-db " + config['silvadatabase'],
except (KeyError, TypeError):
    pass

try:
    fastqc_end = config["fastqc-end"]
except (KeyError):
    pass

try:
    fastqc_start = config["fastqc-start"]
except (KeyError):
    pass

try:
    trimmomatic = "--trimmomatic " + config["trimmomatic"]
except (KeyError, TypeError):
    pass


try:
    remove_temp_output = config["remove_temp_output"]
except (KeyError, TypeError):
    pass

try:
    bypass_n_search = config["bypass_n_search"],
except (KeyError, TypeError):
    pass

try:
    nucleotide_db = " --nucleotide-database " + str(config["nucleotide_db"]),
except (KeyError, TypeError):
    pass

try:
    protein_database = "--protein-database " + str(config["protein_db"]),
except (KeyError, TypeError):
    pass

try:
    verbose = config["verbose"]
except (KeyError, TypeError):
    pass


rule all:
    input:
        expand("{dataset}/write_log_{name}.log",name=NAME, dataset=dataset)


rule kneaddata:
    input:
       "{dataset}"
    output:
            # output = "{sample}.fastqc"
        ouput = directory("{dataset}/kneaddata_output/")
    threads: 8

    shell:
        "kneaddata -i {input}/{input}{SAMPLES[0]}.fastq -i {input}/{input}{SAMPLES[1]}.fastq -o {output} {database} {trimmomatic} {fastqc_start} {fastqc_end} {bypass_trf} "


rule reformat_file:
    input:
        input1 ="{dataset}/kneaddata_output",
        data = "{dataset}"

    output: "{dataset}/interleaved_{dataset}.fastq"
    threads: 8
    params:
        file1 = "kneaddata_paired_1.fastq",
        file2 = "kneaddata_paired_2.fastq"

    shell:
        "/Users/bengels/Desktop/StageWetsus2022/BakedInBiobakery/biobakery/appModels/SnakePipeMultiHumaNn/bbmap/reformat.sh in1={input.input1}/{input.data}_R1_{params.file1} in2={input.input1}/{input.data}_R1_{params.file2} out={output}"


rule humannTool:
        input: "{dataset}/interleaved_{dataset}.fastq"
        threads: 2
        output: directory("{dataset}/humantool_output_{name}")

        shell:
            "humann -i {input} -o {output} {protein_database} {bypass_n_search} {nucleotide_db} {verbose} {remove_temp_output} --input-format fastq"

rule write_to_db:
        input: "{dataset}/humantool_output_{name}"
        log: "{dataset}/write_log_{name}.log"
        output: "{dataset}/write_log_{name}.log"
        run:
            from scripts.connect_to_database import DbConnector
            for i in os.listdir(str(input)):
                DbConnector(str(input) + "/" + str(i), 9, 1).write_to_dump_table()






