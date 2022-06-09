# SnakePipeMultiHumaNn
![flowchart humenapipe](dag.svg
)

### Make this pipeline usefull

The only thing you  need to do is changing the patways (the pathways are recognisable trough `[]` ) in the follow files:
* kneaddata.snakefile
* humann.snakefile



For het kneaddata.snakefile this means that you need to change the following in the `export_fastqc` rule:

```shell

mv {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_1} {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_p1} {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_p2} {input.input1}/{params.fastq}/{input.data}_R2_{params.fastqc_1}   [PATHWAYTOBAKEDINBIOBAKERY]/BakedInBiobakery/static/img/fastqc_results/

```

For het humann.snakefile this means that you need to change the following in the `reformat_file` rule:

```shell

[PATHWAYTOBAKEDINBIOBAKERY]/BakedInBiobakery/biobakery/appModels/SnakePipeMultiHumaNn/bbmap/reformat.sh in1={input.input1}/{input.data}_R1_{params.file1} in2={input.input1}/{input.data}_R1_{params.file2} out={output}

```

**Explanation rules not yet added**
