#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
 * A Nextflow DSL2 script that simulates data generation,
 * performs parallel processing, and aggregates results without requiring external input.
 */

// Define pipeline parameters
params.outdir = 'results' // Output directory

// Module for data generation
process GenerateData {
    executor("slurm")
    queue("c2s4")
    cache('lenient')
    
    tag "Generating data"

    input:
    val chr

    output:
    path "${chr}"

    shell: template 'generate_data.sh'
}

// Module for processing data
process ProcessData {
    executor("slurm")
    queue("c2s4")
    cache('lenient')

    tag "Processing ${chr}"

    input:
    path chr

    output:
    path "processed_*" 

    shell:  template 'process_data.sh'
}

// Module for aggregating results
process AggregateResults {
    executor("slurm")
    queue("c2s4")
    cache('lenient')

    tag "Aggregating results"

    input:
    path processed_files

    output:
    path "aggregated_results.txt"

    shell: template 'aggregate_results.sh'
}

// Define workflow
workflow {
    chr = Channel.from(1..3)
    // Data generation
    generatedData = GenerateData(chr)
    // print generateData.out.collect()
    // Data processing
    // processedData = generateData.out.collect().map(ProcessData)
    processedData = ProcessData(generatedData)
    // Results aggregation
    aggregateResults = processedData.collect().set { processedFiles }
    AggregateResults(processedFiles)

}
