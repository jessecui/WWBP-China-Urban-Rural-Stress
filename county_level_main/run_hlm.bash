#!/bin/sh
set -e

echo "Running HLM on LIWC Categories"
Rscript hlm_model.R data/liwc_features.csv script_results/liwc_results.csv

echo "Running HLM on LDA Categories"
Rscript hlm_model.R data/lda_features.csv script_results/lda_results.csv

echo "Running HLM on Phrases Categories"
Rscript hlm_model.R data/phrases_features.csv script_results/phrases_results.csv
