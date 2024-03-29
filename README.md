# SnakePipeMultiHumaNn
*Contact:*

*Author: Bart Engels*
<br>
*Website: www.bartengels.eu*
<br>
*Email: b.engels@bioinf.nl*
<br>
*Version: v1*



![flowchart humenapipe](dag.svg
)

### Intergrade the backbone of the [BakedinBiobakery](https://github.com/GitMasterBart/BakedInBiobakery) by setting-up this pipeline

1. [Install](#install)
2. [Virtual env](#venv)
3. [Pathways](#path)
4. [Rules](#rul)
      1. [Rules from kneaddata.snakefile](#rul1)
      2. [Rules from humann.snakefile](#rul2)
      3. [Rules from databaseparsing.snakefile](#rul3)
     

<a name="install"></a>
**Install** 

Install the bbmap packages because you need the bbmap/reformat.sh file. 
This can be done on: https://sourceforge.net/projects/bbmap/
and plays it in de root of your snakemake file. 

<a name="venv"></a>
**Virtual env**

Because this is part of the BakedinBiobakery, the general idea is that the venv that is used to runs the application also includes tools and packages that are used for this pipeline. 

These are:

* biobakery
* snakemake 
* bowtie2


<a name="path"></a>
**Pathways**


The only thing you need to do is changing the patways (the pathways are recognisable trough `[]` ) in the follow files:
* kneaddata.snakefile
* humann.snakefile

You do not need to alter databaseparser.snakefile in any way. 


For het kneaddata.snakefile this means that you need to change the following in the `export_fastqc` rule:

```shell

mv {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_1} {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_p1} {input.input1}/{params.fastq}/{input.data}_R1_{params.fastqc_p2} {input.input1}/{params.fastq}/{input.data}_R2_{params.fastqc_1}   [PATHWAYTOBAKEDINBIOBAKERY]/BakedInBiobakery/static/img/fastqc_results/

```

For het humann.snakefile this means that you need to change the following in the `reformat_file` rule:

```shell

[PATHWAYTOBAKEDINBIOBAKERY]/BakedInBiobakery/biobakery/appModels/SnakePipeMultiHumaNn/bbmap/reformat.sh in1={input.input1}/{input.data}_R1_{params.file1} in2={input.input1}/{input.data}_R1_{params.file2} out={output}

```

<a name="rul"></a>
### Rules

In a pipeline the main goal is to go form point A to point D this can be achieved by different smaller steps for example form A -> B -> C to D. A snakemake pipeline is structered in the same way. To make it more usefull and easer to understand I will deddicate a pragrafe of this readme to explane all these rules.

<a name="rul1"></a>
#### Rules from kneaddata.snakefile


`rule kneaddata` is the first rule that is initiated and will conduct the kneaddata (pre processing) step. Depending on the input the user gives the pipeline. Differend tools shuts as Trimmomatic/Fastqc/Bowtie2 will be used on the data. How this tool in the kneaddata tool form the bio-bakery work is out of the scoop of this explanation on what each rules does.


`rule export_fastqc` this rule is only used when the user does not check the fastqc-start and/of start-fastcq-end boxes in the graphic environment. This rule moves the files that are created when kneaddata [^1] executes the fastqc tool. These html files than can be streamed to the page so that the user can compare the output before and after the kneaddata tool is used. 

<a name="rul2"></a>
#### Rules from humann.snakefile

`rule reformat_file` in this rule the bbmap tool `reformat.sh` is used to reformat the paired reads to one interleaved file. This because it is eraser to extract the data in the following rules  

`rule humannTool` as it clearly states runs the HumaNn3.0 [^2] tool provided by Bio-bakery. As with the kneaddata, the way it runs depends on the input from the user. How the parameters influence the human tool can be found in the help manual from the bio-bakery. 

<a name="rul3"></a>
#### Rules from databaseparsing.snakefile

`rule regroup` this rule take the results and create features that are easy for interpretation. This is important in this way the user will be more capable to preform analysis on these results. 


`rule write_to_db` the name of this rules is almost self explanatory but because I will not assume that everyone knows what 'db' means, wil will explane. This rule writes all the results to the database of choice. It uses a script that is atached in the `script` folder named: `connect_to_database.py`.


[^1]: https://github.com/biobakery/biobakery/wiki/kneaddata
[^2]: https://github.com/biobakery/biobakery/wiki/humann3

