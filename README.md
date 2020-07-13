# gunzip_fqgz_process

## This nextflow wrapper helps to implement `gunzip` process of a `fastq` pipeline that includes:

1. Define a default parameter `params.trimmed=true`
2. Check if the `inputRawFilePattern` is trimmed or untrimmed
3. The `trimmed` file has `p` in the file pattern whereas untrimmed file does not have `p` in the file pattern
4. Based on the file pattern the input parameter of the script is defined
5. Execute the script to gunzip the input file using `gzip –dc` command and stores the output into the `publishDir`


## Execute the script by using the following command:

```nextflow run main.nf```

You will see the execution of a `gzip` process.

## Execute it again adding the -resume option as shown below:

```nextflow run main.nf -resume```

The -resume option skips the execution of any step that has been processed in a previous execution.

## Adding a publishDir directive to the gzip process to store the process results into a directory of your choice.

In this script, it stores the result files locally into `results/gzip` directory.