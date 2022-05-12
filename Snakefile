import os

configfile: "config.yaml"

rule all:
    input:
       "kneaddata_output"


rule kneaddata:
    input:
        "/Users/bengels/Desktop/Uploaded_files/demofileswithdi/"
    output:
        ouput = directory("kneaddata_output")
    threads: 8
    params: database = config['silvadatabase'],
            trimmomatic = config["trimmomatic"],
            fastqc_start = config["fastqc-start"],
            fastqc_end = config["fastqc-end"],
            bypass_trf = config["--bypass-trf"]
    run:
        forward = ""
        backward = ""
        # os.system("rm -r /Users/bengels/Desktop/Uploaded_files/demofileswithdi/.DS_Store")
        for i in os.listdir(str(input)):
            print(i)
            for file in os.listdir(str(input)+ "/" + i):
                print(file)
                # print(os.path.join(input, file))
                if "R1" in str(file):
                    forward = str(file)
                elif "R2" in str(file):
                    backward = str(file)
            os.system("kneaddata -i " + str(input)+ "/" + i + "/" +
                      forward + " -i " + str(input)+ "/" + i + "/" +
                      backward + f" -o  {output} {params.trimmomatic} " +
                                 f"{params.fastqc_start} {params.fastqc_end} {params.bypass_trf} {params.database}")
    # -db ~/Desktop/Uploaded_files/humann_dbs/silvadb/ ~/../../Volumes/PHILIPS\ UFD/rRNA_SILVA128/



rule write_files_to_webpage:
    input: fastq_dir = "kneaddata_output/fastqc/",

    output: directory("~/Desktop/StageWetsus2022/BakedInBiobakery/static/img/fastqc_results/")

    shell: "cp -r {input}/*paired_*_fastqc {output} "

rule reformat_file:
    input: "/Users/bengels/Desktop/StageWetsus2022/SnakePipeMultiHumaNn/kneaddata_output"

    output: "/Users/bengels/Desktop/StageWetsus2022/SnakePipeMultiHumaNn/interleave_map/interleaved.fastq"

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
        os.system(f"bbmap/reformat.sh in1={input}/{file1} in2={input}/{file2} out={output}")

rule humann_tool:
    input: "/Users/bengels/Desktop/StageWetsus2022/SnakePipeMultiHumaNn/interleave_map/interleaved.fastq"

