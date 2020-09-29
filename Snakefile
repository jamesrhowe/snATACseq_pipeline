configfile: "config/default_config.yaml"

SAMPLE=config["sample"]
GROUP=config["group"]
THREADS=config["threads"]

rule all:
    input:
        expand("datasets/arrow/{sample}.arrow", sample=SAMPLE)

rule frag_to_arrow:
    input:
        "datasets/raw/{sample}.fragments.tsv.gz"
    output:
        "datasets/arrow/{sample}.arrow"
    threads: THREADS
    log:
        "pipe_info/logs/frag_to_arrow/{sample}/{sample}_frag_to_arrow_snakemake.log.txt"
    benchmark:
        "pipe_info/benchmarks/frag_to_arrow/{sample}/{sample}_frag_to_arrow_snakemake.benchmark.txt"
    shell: """
        Rscript scripts/frag_to_arrow.R --args {input} {output} {wildcards.sample} {threads} 2> {log}
        mv -fv {wildcards.sample}.arrow datasets/arrow/{wildcards.sample}.arrow &&
        rm -rf {wildcards.sample}.arrow
        """
