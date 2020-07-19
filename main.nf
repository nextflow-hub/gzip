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
params.deleteOriginal= false
params.saveBy = 'copy'

/*
################
NEXTFLOW Global Config
################
*/


inputUntrimmedRawFilePattern = "./*_{R1,R2}.fastq.gz"
inputTrimmedRawFilePattern = "./*_{R1,R2}.p.fastq.gz"

inputRawFilePattern = params.trimmed ? inputTrimmedRawFilePattern : inputUntrimmedRawFilePattern

Channel.fromFilePairs(inputRawFilePattern)
        .into { ch_in_gzip; ch_in_deleteOriginal }


/*
################
gzip these files
################
*/


process gzip {
    container 'abhi18av/biodragao_base'
    publishDir 'results/gzip', mode: params.saveBy

    input:
    set genomeName, file(genomeReads) from ch_in_gzip

    output:
    tuple path(genome_1_fq), path(genome_2_fq) into ch_out_gzip

    script:
    outputExtension = params.trimmed ? '.p.fastq' : '.fastq'
    
    // rename the output files
    genome_1_fq = genomeReads[0].name.split("\\.")[0] + outputExtension
    genome_2_fq = genomeReads[1].name.split("\\.")[0] + outputExtension

    """
    gzip -dc ${genomeReads[0]} > ${genome_1_fq} 
    gzip -dc ${genomeReads[1]} > ${genome_2_fq}
    """

}



if(params.deleteOriginal) {

process deleteOriginal {
    container 'abhi18av/biodragao_base'    

    input: 
    tuple genomeName, file(genomeReads) from ch_in_deleteOriginal
    
    script:
    
    """
    rm \$(readlink -f ${genomeReads[0]}) \$(readlink -f ${genomeReads[1]})
    
    """

  }
}


