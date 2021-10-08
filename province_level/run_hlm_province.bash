#!/bin/sh
set -e

echo "Running HLM on LIWC Categories"
Rscript hlm_model_province.R data/liwc_features_province.csv script_results/liwc_results_province.csv

echo "Running HLM on LDA Categories"
Rscript hlm_model_province.R data/lda_features_province.csv script_results/lda_results_province.csv