import os

rule all:
    input:
       directory("kneaddata_output")


rule kneaddata:
    input:
        "/Users/bengels/Desktop/Uploaded_files/demofileswithdi/demofiles_wetsus4000/"
    output:
        ouput = directory("kneaddata_output")
    threads: 8
    run:
        forward = ""
        backward = ""
        for file in os.listdir(str(input)):
            # print(os.path.join(input, file))
            if "R1" in str(file):
                forward = str(file)
            elif "R2" in str(file):
                backward = str(file)
        os.system("kneaddata -i " + str(input) + "/" + forward + " -i " + str(input) + "/" + backward + f" -o {output} --trimmomatic ~/Desktop/kneaddataMap/Trimmomatic-0.36/ --bypass-trf  --run-fastqc-start \
  --run-fastqc-end ")
# -db ~/Desktop/Uploaded_files/humann_dbs/silvadb/



