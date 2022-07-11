rule reformat_file:
"""
Put the R1 and R2 results together in one file. (interleaved file)
"""
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
"""
executes the humaNn3.0 tool from the bio bakery
"""
        input: "{dataset}/interleaved_{dataset}.fastq"
        threads: 8
        output: directory("{dataset}/humantool_output_{name}")

        shell:
            "humann -i {input} -o {output} {protein_database} {bypass_n_search} {nucleotide_db} {verbose} {remove_temp_output} --input-format fastq"
