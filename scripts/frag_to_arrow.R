#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly=TRUE)

# load dependencies
renv::restore()
library(ArchR)

# needed for ArchR to run
addArchRThreads(threads = as.integer(args[5])) # fourth argument (specified as 5, confusingly) given is cores
addArchRGenome("mm10")

# load the arrow file
createArrowFiles(inputFiles = args[2], # first argument (specified as 2, confusingly) gives the input file
                 sampleNames = args[4], # third argument (specificed as 4, confusingly) gives the sample ID
                 removeFilteredCells = FALSE, # keep these for downstream plotting outside of PDFs
                 filterTSS = 4,
                 filterFrags = 1000, 
                 addTileMat = TRUE,
                 addGeneScoreMat = TRUE,
                 QCDir = paste("pipe_info/logs/frag_to_arrow/"), # makes sure it doesn't create a new QC directory, puts into log
                 logFile = paste0("pipe_info/logs/frag_to_arrow/", args[4], "/", args[4], "_createArrow_inRscript.txt")
)

# filter doublets
# needs to be done in this step because no new intermediate file is created, thus doesnt work with snakemake
addDoubletScores(input = args[3], # second argument (specified as 3, confusingly) given in the snakefile is arrow file
                 nTrials = 10, # increase iterations for greater accuracy
                 outDir = paste0("pipe_info/logs/frag_to_arrow/", args[4]), # ensures it stays out of arrow dir, puts into log
                 logFile = paste0("pipe_info/logs/frag_to_arrow/", args[4], "/", args[4], "/addDoubletScores_inRscript.txt")
)