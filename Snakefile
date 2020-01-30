from os.path import join

SRC_DIR = "src"
DATA_DIR = "data"
RAW_DIR = join(DATA_DIR, "raw")
PROCESSED_DIR = join(DATA_DIR, "processed")


rule all:
    input:
        join(RAW_DIR, "chr1_127epigenomes_15observedStates.hierarchy.json")
        #join(PROCESSED_DIR, "chr1_127epigenomes_15observedStates.multires.mv5")

rule clodius:
    input:
        join(RAW_DIR, "{filename}.data.txt"),
        join(RAW_DIR, "{filename}.rowinfo.txt")
    output:
        join(PROCESSED_DIR, "{filename}.multires.mv5")
    shell:
        """
        # TODO
        """

rule rowinfo:
    input:
        data=join(RAW_DIR, "{filename}.data.txt"),
        hierarchy=join(RAW_DIR, "{filename}.hierarchy.json")
    output:
        join(RAW_DIR, "{filename}.rowinfo.txt")
    script:
        join(SRC_DIR, "rowinfo.py")


rule cluster:
    input:
        join(RAW_DIR, "{filename}.data.txt")
    output:
        join(RAW_DIR, "{filename}.hierarchy.json")
    script:
        join(SRC_DIR, "cluster.py")


rule download:
    output:
        join(RAW_DIR, "{filename}.data.txt")
    params:
        file_url="https://github.com/Altius/epilogos/raw/master/data/{filename}.txt.gz"
    shell:
        """
        curl -L -o {output}.gz {params.file_url} && gunzip {output}.gz
        """