import os

configfile: "config.yaml"
workdir: config['inputfiles']

SAMPLES = config["samples"]
NAME = config["name"]

rule all:
    input:
        expand("humantool_output_{name}",name=NAME)


rule kneaddata:
    input:
        expand("{sample}.fastq", sample = SAMPLES),
    params: database=config['silvadatabase'],
        trimmomatic=config["trimmomatic"],
        fastqc_start=config["fastqc-start"],
        fastqc_end=config["fastqc-end"],
        bypass_trf=config["--bypass-trf"],
    output:
            # output = "{sample}.fastqc"
        ouput = directory("kneaddata_output")
    threads: 8
    shell:
        "kneaddata -i {input[0]} -i {input[1]} -o  {output} {params.trimmomatic} {params.fastqc_start} {params.fastqc_end} {params.bypass_trf} {params.database}"


rule reformat_file:
    input: "kneaddata_output"

    output: expand("interleaved_{name}.fastq", name = NAME)
    threads: 8
    run:
        file1 = ""
        file2 = ""
        for file in os.listdir(str(input)):
            # print(os.path.join(input, file))
            # print(file)
            if "paired_1" in str(file):
                file1 = str(file)
            elif "paired_2" in str(file):
                file2 = str(file)
        os.system(f"/Users/bengels/Desktop/StageWetsus2022/SnakePipeMultiHumaNn/bbmap/reformat.sh in1={input}/{file1} in2={input}/{file2} out={output}")


# def find_files_in_directories(file_path):
#         """
#         Scrapes the directory that is given as variable file_pathway
#         :return: void
#         """
#         list_files = []
#         for file in os.listdir(file_path):
#             objects_in_directory = os.path.join(file_path, file)
#             # checking if it is a file
#             if os.path.isfile(objects_in_directory):
#                 list_files.append(objects_in_directory)
#         return list_files
#
#
# interleave_list = find_files_in_directories(config["interleave_map"])

rule humannTool:
        input: expand("interleaved_{name}.fastq", name = NAME)
        params:
            protein_database=config["protein-db"],
            bypass_n_search=config["bypass-n-search"],
            nucleotide_db=config["nucleotide_db"]
        threads: 2
        output: directory(expand("humantool_output_{name}",name=NAME))

        shell:
            "humann -i {input} -o {output} {params.protein_database} {params.bypass_n_search} {params.nucleotide_db}"

