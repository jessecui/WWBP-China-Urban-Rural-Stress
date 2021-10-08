# Hierarchical Linear Models (HLMs) to Measure Urban-Rural Stress Expressions Differences in China


HLMs allow us to model the contribution of regional characteristics on individuals language. We use HLMs to measure urban/rural differences in stress expressions in China after text-mining from Weibo posts that discuss stress.

The description of the data and model is part of our paper published at AAAI ICWSM 2022. Preprint: (to include)

## Directory Structure
** `Supplementary_Materials.pdf`: This file contains the supplementary materials for our paper.
** `/county_level_main`: This directory contains data and code to run the main county-level HLM. 
** `/county_level_post_stratified`: This directory contains the data and code to run the HLM on the county-level with post-stratified weights on gender.
** `/province_level`: This directory contains data and code to run HLM on the province-level
** `/reference_data`: This directory contains files to view reference data, such as the words in each LDA topic, LIWC categories, frequency occurrenecs of phrases, and province gender ratios used to calculate post-stratified weights.

## Usage
Each directory with HLM scripts should have a corresponding bash file to run to retrieve correlations from the HLM model. These results are also already included in the repo in the `/script_results` folder for each directory that includes a script. Raw data is in the `/data` folder and the HLM code itself is in a corresponding `hlm_model.R` file.

Run the bash script as follows to run HLM:
`bash run_hlm.bash`

## Citation
```
    @article{cui2022icwsm,
    title={Understanding Urban-Rural Differences in Stress in China Using Hierarchical Linear Modeling},
    author={Cui, Jesse and Zhang, Tingdan and Pang, Dandan and Jaidka, Kokil and Sherman, Garrick and Jakhetiya, Vinit and Ungar, Lyle, and Guntuku, Sharath Chandra},
    journal={Proceedings of the International AAAI Conference on Web and Social Media}, 
    year={2022}
    }
```

```
APA
Cui, J., Zhang, T., Pang, D., Jaidka, D., Sherman, G., Jakhetiya, V., Ungar, L., & Guntuku, S. C. (2022). Understanding Urban-Rural Differences in Stress in China Using Hierarchical Linear Modeling. Proceedings of the International AAAI Conference on Web and Social Media (ICWSM)
```
