# get_sas() function

This function is used to import SAS datasets into R.  
The user needs to have SAS installed on their machine,  

The function consists of 2 steps:

1. Call SAS in batch mode to execute PROC EXPORT to CSV
2. Read from CSV file to R data.frame or data.table

Works on Windows. But adding a Mac option should be easy.



## Usage
sas_lib <- 'C:/SBA_FOIA_2014' # SAS library folder  
sas_file <- 'elips_static_7a_caip' # SAS dataset name  


df <- get_sas(sas_lib, sas_file, keep.csv = T) #keeps the intermediary CSV files  
dt <- get_sas(sas_lib, sas_file, data.table = TRUE) #returns results in a data.table