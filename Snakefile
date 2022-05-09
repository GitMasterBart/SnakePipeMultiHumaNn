import os

rule all:
    input:
       "file.txt"


rule complex_conversion:
    input:
        "/Users/bengels/Desktop/Uploaded_files/demofileswithdi/demofiles_wetsus4000/"
    output:
        "file.txt"
    run:
        for file in os.listdir(str(input)):
            # print(os.path.join(input, file))
            file

