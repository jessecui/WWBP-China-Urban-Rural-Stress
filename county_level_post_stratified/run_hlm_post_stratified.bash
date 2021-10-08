#!/bin/sh
set -e

echo "Running Post-Strat weights data processor"
python post_stratify_group_norms.py

echo "Running HLM on LIWC Categories"
Rscript ../county_level_main/hlm_model.R data/liwc_features_poststratified.csv script_results/liwc_results_poststratified.csv

echo "Running HLM on LDA Categories"
Rscript ../county_level_main/hlm_model.R data/lda_features_poststratified.csv script_results/lda_results_poststratified.csv

echo "Running HLM on Phrases Categories"
Rscript ../county_level_main/hlm_model.R data/phrases_features_poststratified.csv script_results/phrases_results_poststratified.csv
