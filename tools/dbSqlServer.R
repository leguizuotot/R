#############################################################################
## Module for SQL SERVER  writing and reading

## https://www.rdocumentation.org/packages/RODBC/versions/1.3-14/topics/sqlSave

## install.packages("RODBC")
library(RODBC)

dbSqlServerQuery <- function(dbhandle, SQLquery){
  
  cat(paste0(Sys.time(), " Running query: ",SQLquery,", please wait ...\n"))
  res <- sqlQuery(dbhandle, SQLquery)

}

dbSqlServerReadTable <- function(myConnection, dbTableName) {
  cat(paste0(Sys.time(), " f(x) dbSqlServerReadTable\n"))
  
  ## sqlsave/saqlfetch argument doesn't support brakets
  ##dbTableName <- sanitizeVariable(dbTableName)
  cat(paste0(Sys.time()," Variable sanitized.\n"))
  
  dbhandle <- odbcDriverConnect(myConnection)
  cat(paste0(Sys.time(), " Connection opened.\n"))
  
  cat(paste0(Sys.time(), " Reading table ", dbTableName," please wait...\n"))
  res <- sqlFetch(dbhandle,dbTableName);
  cat(paste0(Sys.time(), " Reading Done.\n"))

  close(dbhandle)
  cat(paste0(Sys.time(), " Connection closed.\n"))
  
  cat(paste0(Sys.time(), " Data returned, ", nrow(res), " rows.\n"))
  
  return(res) 
}

dbSqlServerWriteDataFrame <- function(myConnection, dbTableName, dataFrame) {
  cat(paste0(Sys.time(), " f(x) dbSqlServerWriteDataFrame\n"))
  
  ## sanitization
  ##dbTableName <- sanitizeVariable(dbTableName)
  cat(paste0(Sys.time(), " Variable sanitized.\n"))
  
  dbhandle <- odbcDriverConnect(myConnection)
  cat(paste0(Sys.time(), " Connection opened.\n"))
  
  ## Creates a backup of the DB tabe before droping it and creating the new one.
  backupTable <- paste0(dbTableName,"_",as.Date(as.character(Sys.Date()), format = "%Y%m%d"), as.Date(as.character(Sys.time()), format = "%H%M") )
  queryBackup <- paste0("IF OBJECT_ID('",dbTableName,"') IS NOT NULL SELECT * INTO ",backupTable," FROM ",dbTableName,";")
  queryDrop <- paste0("IF OBJECT_ID('",dbTableName,"') IS NOT NULL DROP TABLE ",dbTableName,";")
  
  cat(paste0(Sys.time()," Creating backup if required for ",dbTableName, " ...\n"))
  dbSqlServerQuery(dbhandle,queryBackup);
  cat(paste0(Sys.time()," Backup done, ",backupTable, ".\n")) ## el backup no se esta creando, creo q el problema es 'backupTable', deberia ser yymmddHHMM
  
  cat(paste0(Sys.time()," Droping table if exists ",dbTableName, ".\n"))
  dbSqlServerQuery(dbhandle,queryDrop);
  cat(paste0(Sys.time()," Drop done, ",dbTableName, ".\n"))
  
  cat(paste0(Sys.time()," Creating table ",dbTableName," and inserting data, please wait ... \n"))
  sqlSave(dbhandle,dataFrame,tablename=dbTableName,rownames=FALSE,colnames=FALSE,safer=FALSE,fast=TRUE, append=FALSE); ## lo hace bien pero esta grabando la primera fila que se supone solo es nombre de campos
  cat(paste0(Sys.time()," Table creation and data insertion done.\n"))
  
  ## Checks the number of rows inserted
  queryCount <- paste0("select count(1) as N from ",dbTableName)
  responseCount <- dbSqlServerQuery(dbhandle,queryCount)
  responseCount <- toString(responseCount[1,1], width = NULL)
  cat(paste0(Sys.time()," ", nrow(dataFrame), " rows to insert, ", responseCount," inserted into table ",dbTableName,".\n")) ## todo bien menos el responsecount que no sale nada :()
  
  close(dbhandle)
  cat(paste0(Sys.time(), " Connection closed.\n"))
  
}

sanitizeVariable <- function(dbTableName) {
  ## R sqlsave/saqlfetch argument doesn't support brakets
  gsub("[", "", dbTableName) ## ESTO DA ERROR :(
  gsub("]", "", dbTableName) ## ESTO DA ERROR :(
  
  ## basic sqlinjection issues
  gsub("'", "", dbTableName)
  gsub("\"", "", dbTableName)
  gsub("=", "", dbTableName)
  gsub(">", "", dbTableName)
  gsub("<", "", dbTableName)
  gsub("!", "", dbTableName)
  gsub("*", "", dbTableName)
  gsub("\n", "", dbTableName)
  
  return(dbTableName)
}

