import os

configfile: "config.yaml"


workDIR = config['inputfiles']
workdir: config['inputfiles']
SAMPLES = config["samples"]
name =  "Non_name_specified"
dataset = config["dataset"]
trimmomatic = "--bypass-trim"
fastqc_start = " "
fastqc_end = " "
bypass_trf = "--bypass-trf"
database = " "

#userdata
user_intials_index = config["user_index"]
research_index = config["research_index"]

remove_temp_output = " "
verbose = " "
bypass_n_search = " "
nucleotide_db =" "
protein_database = ""
## variables

try:
    name = config["name"]
except (KeyError, TypeError):
    pass

try:
    database = "-db " + config['silvadatabase'],
except (KeyError, TypeError):
    pass

try:
    fastqc_end = config["fastqc_end"]
except (KeyError):
    pass

try:
    fastqc_start = config["fastqc_start"]
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

include: "kneaddata.snakefile"
include: "humann.snakefile"
include: "databaseparser.snakefile"

rule all:
    input:
        expand("{dataset}/write_log_{name}.log",name=name,dataset=dataset)















