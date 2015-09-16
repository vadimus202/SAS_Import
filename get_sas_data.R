

get_sas <- function(
  sas_lib,
  sas_file, 
  keep.csv = FALSE,
  csv_dir = getwd(),
  sas_loc = 'C:/Program Files/SASHome/SASFoundation/9.3',
  data.table = FALSE
){
  
  # SAS executable
  sascmd = file.path(sas_loc, "sas.exe")
  if (.Platform$OS.type == "windows") 
    sascmd <- paste(shQuote(sascmd), "-sysin")
  
  # csv output
  csv_file <- file.path(csv_dir, paste0(sas_file,'.csv'))
  
  # SAS export to csv program
  prog <- paste0(
    'libname in ', shQuote(file.path(sas_lib)), ';\n',
    'proc export data=in.', sas_file, '\n',
    'outfile=', shQuote(csv_file), '\n',
    'dbms=csv replace; \n',
    'run;'
  )
  tmpProg <- tempfile()
  cat(prog, file = tmpProg)
  
  # log file
  log_file <- file.path(getwd(),paste0(basename(tmpProg),".log"))
  
  # Execute SAS export to CSV
  sasrun <- try(sysret <- system(paste(sascmd, tmpProg)))
  
  if (!inherits(sasrun, "try-error") & sysret == 0L) {
    unlink(tmpProg)
    unlink(log_file)
    
    if(file.exists(csv_file)){
      if(data.table){
        library(bit64)
        library(data.table)
        zz <- fread(csv_file, stringsAsFactors = F)
      } else {
        zz <- read.csv(csv_file, stringsAsFactors = F)
      }
      
      if(!keep.csv) file.remove(csv_file)
      return(zz)
      
    }
  } else {
    cat("SAS failed.\n",
        "SAS program at", tmpProg, "\n",
        "Log file at ", log_file ,"\n")
    warning(gettextf("SAS return code was %d", sysret), domain = NA)
    return(NULL)
  }
  
}







