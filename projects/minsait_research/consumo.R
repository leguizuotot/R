#######################################################
######## ENTORNO DEL PROYECTO #########################

## configuración de base de datos de trabajo
server <- "40.115.26.178"
database <- "MUSGRAVE"
user <- "sqlcsa"
password <- "Zaragoza1"
myConnection <- paste0("driver={SQL Server};server=",server,";database=",database,";uid=",user,";pwd=",password)

## install.packages("RODBC")
source("tools/dbSqlServer.R")   ## FUNCIONES PARA LEER Y ESCRIBIR TABLAS EN LA BASE DE DATOS
  ## dbSqlServerReadTable <- function(myConnection, dbTableName)
  ## dbSqlServerWriteDataFrame <- function(myConnection, dbTableName, dataFrame)


#######################################################
######## COMIENZO DEL PROGRAMA#########################

## consulta de carga de información ibc.zzz_test_cestes_new
inputTable <- "ibc.zzz_test_cestes_new"
inputTable_response <- dbSqlServerReadTable(myConnection, inputTable)

outputTable <- "ibc.zzz_test_cestes_new_escribe_R_2"
dbSqlServerWriteDataFrame(myConnection, outputTable, inputTable_response)

## NO MIRES DEBAJO DE ESTO ALBERT :)


#######################################################
#######################################################
#######################################################


x <- seq (0,100) 

vector1 <-  c(1.2, 45, "prueba")
y <- 37
z <- 45






read.csv("Functions/carsmt.csv")

## read lee texto plano, tienes que especificar el metodo de carga
?read.csv

tabla_coches <- read.csv("Functions/carsmt.csv", header = TRUE, sep = ";", DEC = ".")

tabla_coches[c("Merc 280","Merc 280C"),]
length(rownames(tabla_coches))
plot(tabla_coches$mpg, tabla_coches$cyl, col = rainbow(length(rownames(tabla_coches))))

# seq(a,b)  secuencia de datos
# rep("A",10) repito el elemento 10 veces
# cat devuelve el numero de caracteres de una cadena

function1 <- function(x, y){
  if (x+y < 0){
    cat("#error, los valores suman negativo\n")
    return()
  }
  else{
    aux <- sqrt(2*(x + y))
    return(aux)  
  }
}

prueba <- function1(-4,4)
