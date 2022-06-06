rule kneaddata:
    input:
       "{dataset}"
    output:
            # output = "{sample}.fastqc"
        ouput = directory("{dataset}/kneaddata_output/")
    threads: 16

    shell:
        "kneaddata -i {input}/{input}{SAMPLES[0]}.fastq -i {input}/{input}{SAMPLES[1]}.fastq -o {output} {database} {trimmomatic} {fastqc_start} {fastqc_end} {bypass_trf} "



rule export_fastqc:
    input:
        input1 = "{dataset}/kneaddata_output/",
        data= "{dataset}"
    threads: 16
    log: "{dataset}/export_fastqc_{name}.log"
    output: "{dataset}/export_fastqc_{name}.log"
    params:
            fastqc_p1 = "kneaddata_paired_1_fastqc.html",
            fastqc_p2 = "kneaddata_paired_2_fastqc.html",
            fastqc_1 =  "fastqc.html",
            fastq = "fastqc"

    shell:
        "mv {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_1} {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_p1} {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_p2} {input.input1}/{params.fastq}/{input.data}_R2_{params.fastqc_1}   ~/Desktop/StageWetsus2022/BakedInBiobakery/static/img/fastqc_results/"