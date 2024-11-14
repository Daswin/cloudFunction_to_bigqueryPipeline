# cloudFunction_to_bigqueryPipeline
when a csv is added to a storage bucket use cloud function only to push and append to a bigquery dataset and table.
Emphasis on the csv. I was uploadling xlsx files and wondering why I was getting errors in the logs 

in the interest of space I'm only uploading 2 of the data files. the dataset can be found on kaggle: https://www.kaggle.com/datasets/carrie1/ecommerce-data


#note well
remember to create the requirements.txt file when doing zip function deployment. Function deployment will fail without it