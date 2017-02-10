#############################################################################
## FUNCIÓN PARA CONEXIÓN A BASE DE DATOS SQL Server

## install.packages("RODBC")
library(RODBC)

dbSqlServerQuery <- function(myConnection, SQLquery){
  
  dbhandle <- odbcDriverConnect(myConnection)
  cat("conection opened\n")
  
  res <- sqlQuery(dbhandle, SQLquery)
  cat("data fetched\n")
  
  close(dbhandle)
  cat("conection closed\n")
  
  return(res)
  
}

dbSqlServerWriteDataFrame <- function(myConnection, dataFrame, dbTableName) {
  
  dbhandle <- odbcDriverConnect(myConnection)
  cat("conection opened\n")
  
  sqlSave(dbhandle,dataFrame,tablename=dbTableName,rownames=FALSE,colnames=TRUE,safer=TRUE,fast=TRUE, append=TRUE);
  cat("data inserted\n")
  
  writeCountTest <- paste0("select count(1) from ",dbTableName)
  cat(paste0(writeCountTest," registries inserted into table ",dbTableName,".\n"))
  
  close(dbhandle)
  cat("conection closed\n")
  
}
