import os

configfile: "config.yaml"


workDIR = config['inputfiles']
workdir: config['inputfiles']
SAMPLES = config["samples"]
NAME = config["name"]
dataset = config["dataset"]
trimmomatic = "--bypass-trim"
fastqc_start = ""
fastqc_end = ""
bypass_trf = ""
database = ""

## variables
try:
    database = "-db " + config['silvadatabase'],
except (KeyError, TypeError):
    pass

try:
    fastqc_end = config["fastqc-end"]
except (KeyError, TypeError):
    pass

try:
    fastqc_start = config["fastqc-start"]
except (KeyError, TypeError):
    pass

try:
    trimmomatic = "--trimmomatic " + config["trimmomatic"],
except (KeyError, TypeError):
    pass

try:
    bypass_trf = config["bypass_trf"],
except (KeyError, TypeError):
    pass


rule all:
    input:
        expand("{dataset}/humantool_output_{name}",name=NAME, dataset=dataset)


rule kneaddata:
    input:
       "{dataset}"
    output:
            # output = "{sample}.fastqc"
        ouput = directory("{dataset}/kneaddata_output")
    threads: 8

    shell:
        "kneaddata -i {input}/{input}{SAMPLES[0]}.fastq -i {input}/{input}{SAMPLES[1]}.fastq -o  {output} {trimmomatic} {fastqc_start} {fastqc_end} {bypass_trf} {database}"


rule reformat_file:
    input:
        input1 ="{dataset}/kneaddata_output",
        data = "{dataset}"

    output: "{dataset}/interleaved.fastq"
    threads: 8
    params:
        file1 = "kneaddata_paired_1.fastq",
        file2 = "kneaddata_paired_2.fastq"

    shell:
        "/Users/bengels/Desktop/StageWetsus2022/BakedInBiobakery/biobakery/appModels/SnakePipeMultiHumaNn/bbmap/reformat.sh in1={input.input1}/{input.data}_R1_{params.file1} in2={input.input1}/{input.data}_R1_{params.file2} out={output}"
    # run:
    #demofile_wetsus_0/kneaddata_output/demofile_wetsus_0_R1_kneaddata_paired_1.fastq
    #demofile_wetsus_0/kneaddata_output/demofile_wetsus_0_R1_kneaddata_paired_1.fastq
    #     file1 = ""
    #     file2 = ""
    #     for folder in str(input).split(" "):
    #         for path in os.listdir(str(folder)):
    #             # print(f)
    #             if "paired_1" in str(path):
    #                 file1 = str(path)
    #             elif "paired_2" in str(path):
    #                 file2 = str(path)
    #     for o in str(output).split(" "):
    #         os.system(f"/Users/bengels/Desktop/StageWetsus2022/SnakePipeMultiHumaNn/bbmap/reformat.sh in1={folder}/{file1} in2={folder}/{file2} out={o}")


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
        input: "{dataset}/interleaved.fastq"
        params:
            protein_database="--protein-database " + str(config["protein_db"]),
            bypass_n_search=config["bypass_n_search"],
            nucleotide_db=" --nucleotide-database " + config["nucleotide_db"]
        threads: 2
        output: directory("{dataset}/humantool_output_{name}")

        shell:
            "humann -i {input} -o {output} {params.protein_database} {params.bypass_n_search} {params.nucleotide_db} --input-format fastq"

# rule write_to_db:
#         # input: "{dataset}/humantool_output_{name}/interleaved_map_name_genefamilies.tsv"
#         # output: "{dataset}/log_{name}.log"
#         run:
#             from biobakery.appModels import write_to_database
#             create_db = write_to_database.WriteToDb("/Users/bengels/Desktop/Uploaded_files/demofiles_wetsusR1R2_v1/humantool_output_map_name/interleaved_map_name_genefamilies.tsv", "beng", "Microbiologie", "2022-05-03", "FirstTestOnderzoek")
#             create_db.add_results_to_db()




