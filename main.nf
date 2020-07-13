#!/usr/bin/env nextflow

/*
#######################
Code documentation
#######################
1. Define a default parameter `params.trimmed=true`
2. Check if the `inputRawFilePattern` is trimmed or untrimmed
3. The `trimmed` file has `p` in the file pattern whereas untrimmed file does not have `p` in the file pattern
4. Based on the file pattern the input parameter of the script is defined
5. Execute the script to gunzip the input file using `gzip –dc` command and stores the output into the `publishDir`
*/

/*
################
params
################
*/

params.trimmed=true


/*
################
NEXTFLOW Global Config
################
*/


inputUntrimmedRawFilePattern = "./*_{R1,R2}.fastq.gz"


inputTrimmedRawFilePattern = "./*_{R1,R2}.p.fastq.gz"

inputRawFilePattern = params.trimmed ? inputTrimmedRawFilePattern : inputUntrimmedRawFilePattern

Channel.fromFilePairs(inputRawFilePattern, flat: true)
        .into { ch_in_gzip }


/*
################
gzip these files
################
*/


process gzip {
    container 'abhi18av/biodragao_base'
    publishDir 'results/gzip'

    input:
    tuple (genomeName, path(read_1_gz), path(read_2_gz)) from ch_in_gzip

    output:
    tuple path(genome_1_fq), path(genome_2_fq) into ch_out_gzip

    script:
    outputExtension = params.trimmed ? '.p.fastq' : '.fastq'
    
    // rename the output files
    // G04880_R1.p.fastq.gz > G04880_R1.p.fastq
    genome_1_fq = read_1_gz.name.split("\\.")[0] + outputExtension
    genome_2_fq = read_2_gz.name.split("\\.")[0] + outputExtension

    """
    gzip -dc ${read_1_gz} > ${genome_1_fq} 
    gzip -dc ${read_2_gz} > ${genome_2_fq}
    """
//gzip -dc G04880_R1.p.fastq.gz > G04880_R1.p.fastq
}
