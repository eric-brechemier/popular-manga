-- import all CSV files into separate tables
.echo on
.mode csv

-- nytimes.com
.import ../step1/nytimes_2015_api_get_best_seller_list_names.csv nytimes_2015_api_get_best_seller_list_names
.import ../step1/nytimes_manga_best_seller_lists.csv nytimes_manga_best_seller_lists

.tables

.once sources.sql
.dump
