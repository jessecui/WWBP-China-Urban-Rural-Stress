#!/usr/bin/env python
# coding: utf-8
import pandas as pd

def get_balanced_group_norm (row):
    if row['gender_isFemale']:
        return row['group_norm'] * row['post_strat_factor']
    else:
        return row['group_norm'] / row['post_strat_factor']

file_prefix = '../county_level_main/data/'
files_to_transform = ['liwc_features.csv', 'lda_features.csv', 'phrases_features.csv']
gender_data = pd.read_csv("../reference_data/province_gender_ratios.csv")

for file in files_to_transform:
    print('Post stratifying data for file: ' + file)
    lang_data = pd.read_csv(file_prefix + file)
    
    lang_data_with_post_strat = lang_data.merge(gender_data, how="left", left_on="city_id", right_on="County")
    lang_data_with_post_strat['group_norm'] = lang_data_with_post_strat.apply(lambda row: get_balanced_group_norm(row), axis=1)
    lang_data_with_post_strat = lang_data_with_post_strat.drop(columns=['County', 'Province', 'Weibo_MF_Ratio', 'Pop_MF_Ratio', 'post_strat_factor'])
    
    lang_data_with_post_strat.to_csv('data/' + file[:-4] + '_poststratified.csv', index=False)