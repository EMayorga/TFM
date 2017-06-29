## 6. Variables de tipo FACTOR

##En esta ruta est? el script que nos ha enviado Israel por correo 
setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM/archivos_datos_drive") ## ruta curro
#setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil
#setwd("C:/Users/sergi/Downloads/TFM-master (3)/TFM-master") ##RUTA SERGIO
vuelos <- read.table("vuelosDatosAtmosfericos.csv", header = T, sep = ",")



vuelosDeparted <- vuelos
##vuelosDeparted2 <- vuelosDeparted
## Ya que muchas de estas variables estan compuestas por demasiados valores como para analizarlos uno por uno
## decidimos agrupar los valores de estas variables en funcion del retraso medio para cada uno de ellos.

## FUNCIONES GENERICAS A UTILIZAR

## Funcion que calcula el retraso medio de los valores indicados en la variable de entrada numVuelos e informa
## de la cantidad de vuelos que ha realizado un avion.
## Devuelve un dataframe que almacena el valor de entrada, su retraso medio y el numero de apariciones (o vuelos)
mediasRetrasos <- function(numVuelos, muestra){
  vectorCodigos <- vector()
  vectorRetrasos <- vector()
  vectorNumeroVuelos <- vector()
  
  ## bucle for por cada codigo de vuelo
  for(i in 1:length(numVuelos)){
    
    vuelos <- muestra[muestra[,2]==numVuelos[i],]
    retrasoMedio <- 0
    
    if(length(vuelos[,1])>0){
      retrasoMedio <- mean(vuelos[,1])
    }
    
    vectorCodigos[i] = as.character(numVuelos[i])
    vectorRetrasos[i] = as.numeric(retrasoMedio)    
    vectorNumeroVuelos[i] <- length(vuelos[,1])
    
  }
  df <- as.data.frame(list(vectorCodigos,vectorRetrasos,vectorNumeroVuelos), col.names = c("codigo","retrasoMedio","numeroVuelos"))
  return(df)
}

### Funcion que asigna pesos a las variables en funcion de su retraso medio. Cuanto menor sea su retraso medio menor
### será el peso asignado
asignarPesos <- function(dfRetrasoMedio){
  
  dfRetrasoMedioOrdenado <- dfRetrasoMedio[order(dfRetrasoMedio[,2]),]
  v <- 1:length(dfRetrasoMedioOrdenado[,2])
  dfRetrasoMedioOrdenado[,4] <- v
  
  return(dfRetrasoMedioOrdenado)
}


### Funcion que, dado el dataframe con todos los valores, asigna el peso correspondiente que tiene cada valor
asignarPesosDF <- function(codigos, dfCodigosGrupos){
  ## codigos -> vector del dataframe total con los codigos 
  ## dfCodigosGrupos -> df con los codigos y su retraso
  ## La funcion devuelve un vector indicando el peso que tiene cada valor del vector codigos
  
  vectorSalida <- vector()
  codigosVuelo <- as.character(codigos)
  vectorCodigos <- as.character(dfCodigosGrupos[,1])
  vectorGrupos <- dfCodigosGrupos[,2]
  
  for (i in 1:length(codigosVuelo)){
    for(j in 1:length(vectorCodigos)){
      if (codigosVuelo[i] == vectorCodigos[j]){
        vectorSalida[i] = vectorGrupos[j]
      }
    }
  }
  return(as.integer(vectorSalida))
}


##################################################################################################




## 6.1. Flight_Number
## 6.1.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","flight_number"))
variables <- unique(df$flight_number)
mediaRetrasosVuelo <- mediasRetrasos(variables,df)
#boxplot(mediaRetrasosVuelo$retrasoMedio)
#barplot(mediaRetrasosVuelo$retrasoMedio)
#summary(mediaRetrasosVuelo$retrasoMedio)
#str(mediaRetrasosVuelo)


## 6.1.2. A?adir al dataframe de vuelos una columna con los pesos para cada numero de vuelo
mediaRetrasosVuelo$peso <- 0
mediaRetrasosVuelo <- asignarPesos(mediaRetrasosVuelo)
## Comprobamos que se han indicado correctamente los grupos
#head(mediaRetrasosVuelo)
#summary(mediaRetrasosVuelo)
#table(mediaRetrasosVuelo$pesosFligthNumber)


## 6.1.3 Añadir el nuevo vector al dataframe de vuelos
dfCodigoGrupo <- mediaRetrasosVuelo
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesosFligthNumber <- asignarPesosDF(vuelosDeparted$flight_number,dfCodigoGrupo)
#summary(vuelosDeparted$pesosFligthNumber)
#str(vuelosDeparted$pesosFligthNumber)


## 6.1.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesosFligthNumber <- vuelosDeparted$pesosFligthNumber
############  vuelosDeparted2$flight_number <- NULL

## Comprobacion de asignacion de grupo
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==3,]
#vuelosDeparted2[vuelosDeparted2$flight_number == 4623,]
#table(vuelosDeparted2$pesosFligthNumber)


####################################################################







## 6.2. Variable board_point
## 6.2.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","board_point"))
variables <- unique(df$board_point)
mediaPuntoEmbarque <- mediasRetrasos(variables,df)
#boxplot(mediaPuntoEmbarque$retrasoMedio)
#barplot(mediaPuntoEmbarque$retrasoMedio)
#summary(mediaPuntoEmbarque$retrasoMedio)
#str(mediaPuntoEmbarque)


### 6.2.2. A?adir al dataframe una columna con los pesos 
mediaPuntoEmbarque$pesos <- 0
mediaPuntoEmbarque <- asignarPesos(mediaPuntoEmbarque)
## Comprobamos que se han indicado correctamente los grupos
#head(mediaPuntoEmbarque)
#summary(mediaPuntoEmbarque)
#str(mediaPuntoEmbarque)
#table(mediaPuntoEmbarque$boardPointGroup)


## 6.2.3 Añadir el nuevo vector al dataframe de vuelos
dfCodigoGrupo <- mediaPuntoEmbarque
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesosBoardPoint <- asignarPesosDF(vuelosDeparted$board_point ,dfCodigoGrupo)
#summary(vuelosDeparted$pesosBoardPoint)
#str(vuelosDeparted$pesosBoardPoint)

## 6.2.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesosBoardPoint <- vuelosDeparted$pesosBoardPoint
##############vuelosDeparted2$board_point <- NULL

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesosBoardPoint)


#head(vuelosDeparted)

###################################################################### 





## 6.3 Board_lat (COMPLETADA)
## 6.3.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","board_lat"))
variables <- unique(df$board_lat)
mediaLatEmbarque <- mediasRetrasos(variables,df)
#boxplot(mediaLatEmbarque$retrasoMedio)
#barplot(mediaLatEmbarque$retrasoMedio)
#summary(mediaLatEmbarque$retrasoMedio)
#str(mediaLatEmbarque)


## 6.3.2. Funcion para a?adir al dataframe una columna con los pesos
mediaLatEmbarque$pesos <- 0
mediaLatEmbarque <- asignarPesos(mediaLatEmbarque)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaLatEmbarque)
#summary(mediaLatEmbarque)

## 6.3.3 Añadir el nuevo vector al dataframe de vuelos
dfCodigoGrupo <- mediaLatEmbarque
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesosBoardLat <- asignarPesosDF(vuelosDeparted$board_lat ,dfCodigoGrupo)
#summary(vuelosDeparted$pesosBoardLat)
#str(vuelosDeparted$pesosBoardLat)

## 6.3.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesosBoardLat <- vuelosDeparted$pesosBoardLat
################vuelosDeparted2$board_lat <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$pesos==2,]
#vuelosDeparted2[vuelosDeparted2$board_lat == 41.28667,]

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesosBoardLat)


###################################################################### 






## 6.4 Board_lon (COMPLETADA)
## 6.4.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","board_lon"))
variables <- unique(df$board_lon)
mediaBoardLon <- mediasRetrasos(variables,df)
#boxplot(mediaBoardLon$retrasoMedio)
#barplot(mediaBoardLon$retrasoMedio, names.arg=mediaBoardLon$codigo)
#summary(mediaBoardLon$retrasoMedio)
#str(mediaBoardLon)


## 6.4.3 Funcion para a?adir al dataframe una columna con los pesos
mediaBoardLon$peso <- 0
mediaBoardLon <- asignarPesos(mediaBoardLon)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaBoardLon)
#summary(mediaBoardLon)

## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaBoardLon
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL


## 6.4.4 Añadir el nuevo vector al dataframe de vuelos
vuelosDeparted$pesosBoardLon <- asignarPesosDF(vuelosDeparted$board_lon ,dfCodigoGrupo)
#summary(vuelosDeparted$pesosBoardLon)
#str(vuelosDeparted$pesosBoardLon)


## 6.4.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesosBoardLon <- vuelosDeparted$pesosBoardLon
################vuelosDeparted2$board_lon <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==50,]
#vuelosDeparted2[vuelosDeparted2$board_lon == 6.07286,]

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesosBoardLon)


###################################################################### 






## 6.5 Board_country_code (COMPLETADA)
## 6.5.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","board_country_code"))
variables <- unique(df$board_country_code)
mediaBoardCC <- mediasRetrasos(variables,df)
#boxplot(mediaBoardCC$retrasoMedio)
#barplot(mediaBoardCC$retrasoMedio, names.arg=mediaBoardCC$codigo)
#summary(mediaBoardCC$retrasoMedio)
#str(mediaBoardCC)

## 6.5.2 Funcion para a?adir al dataframe una columna con los pesos
mediaBoardCC$peso <- 0
mediaBoardCC <- asignarPesos(mediaBoardCC)
## Comprobamos que se han indicado correctamente los grupos
#head(mediaBoardCC)
#summary(mediaBoardCC)

## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaBoardCC
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

## 6.5.3 Añadir el nuevo vector al dataframe de vuelos
vuelosDeparted$pesosBoardCountryCode <- asignarPesosDF(vuelosDeparted$board_country_code ,dfCodigoGrupo)
#summary(vuelosDeparted$pesosBoardCountryCode)
#str(vuelosDeparted$pesosBoardCountryCode)

## 6.5.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesosBoardCountryCode <- vuelosDeparted$pesosBoardCountryCode
##################vuelosDeparted2$board_country_code <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==53,]
#head(vuelosDeparted2[vuelosDeparted2$board_country_code == "BA",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesosBoardCountryCode)

###################################################################### 





## 6.6 off_point (COMPLETADA)
## 6.6.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_point"))
variables <- unique(df$off_point)
mediaOffPoint <- mediasRetrasos(variables,df)
#boxplot(mediaOffPoint$retrasoMedio)
#barplot(mediaOffPoint$retrasoMedio, names.arg=mediaOffPoint$codigo)
#summary(mediaOffPoint$retrasoMedio)
#str(mediaOffPoint)

## 6.6.2 Funcion para a?adir al dataframe una columna con los pesos
mediaOffPoint$peso <- 0
mediaOffPoint <- asignarPesos(mediaOffPoint)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaOffPoint)
#summary(mediaOffPoint)


## 6.6.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el pesos a los datos del dataframe
dfCodigoGrupo <- mediaOffPoint
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesosOffPoint <- asignarPesosDF(vuelosDeparted$off_point ,dfCodigoGrupo)
#summary(vuelosDeparted$pesosOffPoint)
#str(vuelosDeparted$pesosOffPoint)


## 6.6.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesosOffPoint <- vuelosDeparted$pesosOffPoint
################vuelosDeparted2$off_point <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==47,]
#head(vuelosDeparted2[vuelosDeparted2$off_point == "VIL",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesosOffPoint)


###################################################################### 






## 6.7 off_lat (COMPLETADA)
## 6.7.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_lat"))
variables <- unique(df$off_lat)
mediaOffLat <- mediasRetrasos(variables,df)
#boxplot(mediaOffLat$retrasoMedio)
#barplot(mediaOffLat$retrasoMedio, names.arg=mediaOffLat$codigo)
#summary(mediaOffLat$retrasoMedio)
#str(mediaOffLat)

## 6.7.2 Funcion para a?adir al dataframe una columna con los pesos
mediaOffLat$peso <- 0
mediaOffLat <- asignarPesos(mediaOffLat)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaOffLat)
#summary(mediaOffLat)


## 6.7.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaOffLat
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoOffLat <- asignarPesosDF(vuelosDeparted$off_lat ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoOffLat)
#str(vuelosDeparted$pesoOffLat)


## 6.7.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoOffLat <- vuelosDeparted$pesoOffLat
###############vuelosDeparted2$off_lat <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==35,]
#head(vuelosDeparted2[vuelosDeparted2$off_lat == 21.3292,],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoOffLat)


###################################################################### 






## 6.8 off_lon (COMPLETADA)
## 6.8.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_lon"))
variables <- unique(df$off_lon)
mediaOffLon <- mediasRetrasos(variables,df)
#boxplot(mediaOffLon$retrasoMedio)
#barplot(mediaOffLon$retrasoMedio, names.arg=mediaOffLon$codigo)
#summary(mediaOffLon$retrasoMedio)
#str(mediaOffLon)

## 6.8.2 Funcion para a?adir al dataframe una columna con los pesos
mediaOffLon$peso <- 0
mediaOffLon <- asignarPesos(mediaOffLon)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaOffLon)
#summary(mediaOffLon)


## 6.8.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaOffLon
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoOffLon <- asignarPesosDF(vuelosDeparted$off_lon ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoOffLon)
#str(vuelosDeparted$pesoOffLon)


## 6.8.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoOffLon <- vuelosDeparted$pesoOffLon
###############vuelosDeparted2$off_lon <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==41,]
#head(vuelosDeparted2[vuelosDeparted2$off_lon == 66.60194,],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoOffLon)


###################################################################### 





## 6.9 off_country_code (COMPLETADA)
## 6.9.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_country_code"))
variables <- unique(df$off_country_code)
mediaOffCC <- mediasRetrasos(variables,df)
#boxplot(mediaOffCC$retrasoMedio)
#barplot(mediaOffCC$retrasoMedio, names.arg=mediaOffCC$codigo)
#summary(mediaOffCC$retrasoMedio)
#str(mediaOffCC)

## 6.9.2 Funcion para a?adir al dataframe una columna con los pesos
mediaOffCC$peso <- 0
mediaOffCC <- asignarPesos(mediaOffCC)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaOffCC)
#summary(mediaOffCC)


## 6.9.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaOffCC
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoOffCountryCode <- asignarPesosDF(vuelosDeparted$off_country_code ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoOffCountryCode)
#str(vuelosDeparted$pesoOffCountryCode)


## 6.9.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoOffCountryCode <- vuelosDeparted$pesoOffCountryCode
################vuelosDeparted2$off_country_code <- NULL

## Comprobacion de asignacion de grupo
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==3,]
#head(vuelosDeparted2[vuelosDeparted2$off_country_code == "BY",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoOffCountryCode)


###################################################################### 





## 6.10 aircraft_type (COMPLETADA)
## 6.10.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","aircraft_type"))
variables <- unique(df$aircraft_type)
mediaTipoAvion <- mediasRetrasos(variables,df)
#boxplot(mediaTipoAvion$retrasoMedio)
#barplot(mediaTipoAvion$retrasoMedio, names.arg=mediaTipoAvion$codigo)
#summary(mediaTipoAvion$retrasoMedio)
#str(mediaTipoAvion)

## 6.10.3 Funcion para a?adir al dataframe una columna con los pesos
mediaTipoAvion$peso <- 0
mediaTipoAvion <- asignarPesos(mediaTipoAvion)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaTipoAvion)
#summary(mediaTipoAvion)


## 6.10.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaTipoAvion
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoAircraftType <- asignarPesosDF(vuelosDeparted$aircraft_type ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoAircraftType)
#str(vuelosDeparted$pesoAircraftType)



## 6.10.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoAircraftType <- vuelosDeparted$pesoAircraftType
################vuelosDeparted2$aircraft_type <- NULL

## Comprobacion de asignacion de grupo
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==13,]
#head(vuelosDeparted2[vuelosDeparted2$aircraft_type == "75W",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoAircraftType)

###################################################################### 






## 6.11 aircraft_registration_number (COMPLETADA)
## 6.11.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","aircraft_registration_number"))
variables <- unique(df$aircraft_registration_number)
mediaNumRegAvion <- mediasRetrasos(variables,df)
#boxplot(mediaNumRegAvion$retrasoMedio)
#barplot(mediaNumRegAvion$retrasoMedio, names.arg=mediaNumRegAvion$codigo)
#summary(mediaNumRegAvion$retrasoMedio)
#str(mediaNumRegAvion)

## 6.11.2 Funcion para a?adir al dataframe una columna con los pesos
mediaNumRegAvion$peso <- 0
mediaNumRegAvion <- asignarPesos(mediaNumRegAvion)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaNumRegAvion)
#summary(mediaNumRegAvion)


## 6.11.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaNumRegAvion
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoAircraftRegNumber <- asignarPesosDF(vuelosDeparted$aircraft_registration_number ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoAircraftRegNumber)
#str(vuelosDeparted$pesoAircraftRegNumber)


## 6.11.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoAircraftRegNumber <- vuelosDeparted$pesoAircraftRegNumber
########vuelosDeparted2$aircraft_registration_number <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==24,]
#head(vuelosDeparted2[vuelosDeparted2$aircraft_registration_number == "XCOAT",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoAircraftRegNumber)

###################################################################### 






## 6.12 routing (COMPLETADA)
## 6.12.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","routing"))
variables <- unique(df$routing)
mediaRutas <- mediasRetrasos(variables,df)
#boxplot(mediaRutas$retrasoMedio)
#barplot(mediaRutas$retrasoMedio, names.arg=mediaRutas$codigo)
#summary(mediaRutas$retrasoMedio)
#str(mediaRutas)


## 6.12.2 Funcion para a?adir al dataframe una columna con los pesos
mediaRutas$peso <- 0
mediaRutas <- asignarPesos(mediaRutas)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaRutas)
#summary(mediaRutas)


## 6.12.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaRutas
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoRouting <- asignarPesosDF(vuelosDeparted$routing ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoRouting)
#str(vuelosDeparted$pesoRouting)


## 6.12.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoRouting <- vuelosDeparted$pesoRouting
##############vuelosDeparted2$routing <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==75,]
#head(vuelosDeparted2[vuelosDeparted2$routing == "AUH-LEU",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoRouting)

###################################################################### 






## 6.13 mesSalida (COMPLETADA)
## 6.13.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","mesSalida"))
variables <- unique(df$mesSalida)
mediaMesSalida <- mediasRetrasos(variables,df)
#boxplot(mediaMesSalida$retrasoMedio)
#barplot(mediaMesSalida$retrasoMedio, names.arg=mediaMesSalida$codigo)
#summary(mediaMesSalida$retrasoMedio)
#str(mediaMesSalida)

## 6.13.2 Funcion para a?adir al dataframe una columna con los pesos
mediaMesSalida$peso <- 0
mediaMesSalida <- asignarPesos(mediaMesSalida)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaMesSalida)
#summary(mediaMesSalida)


## 6.13.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaMesSalida
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoMesSalida <- asignarPesosDF(vuelosDeparted$mesSalida ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoMesSalida)
#str(vuelosDeparted$pesoMesSalida)


## 6.13.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoMesSalida <- vuelosDeparted$pesoMesSalida
#############vuelosDeparted2$mesSalida <- NULL

## Comprobacion de asignacion de peso
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==3,]
#head(vuelosDeparted2)
#head(vuelosDeparted2[vuelosDeparted2$mesSalida == "4",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoMesSalida)

###################################################################### 





## 6.14 anyoSalida (COMPLETADA)
## No se analiza ya que solo tiene los valores 2015, 2016 y 2017

###################################################################### 





## 6.15 diaSalida (COMPLETADA)
## 6.15.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSalida"))
variables <- unique(df$diaSalida)
mediaDiaSalida <- mediasRetrasos(variables,df)
#boxplot(mediaDiaSalida$retrasoMedio)
#barplot(mediaDiaSalida$retrasoMedio, names.arg=mediaDiaSalida$codigo)
#summary(mediaDiaSalida$retrasoMedio)
#str(mediaDiaSalida)

## 6.15.2 Funcion para a?adir al dataframe una columna con los pesos
mediaDiaSalida$peso <- 0
mediaDiaSalida <- asignarPesos(mediaDiaSalida)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaDiaSalida)
#summary(mediaDiaSalida)


## 6.15.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaDiaSalida
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoDiaSalida <- asignarPesosDF(vuelosDeparted$diaSalida ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoDiaSalida)
#str(vuelosDeparted$pesoDiaSalida)


## 6.15.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoDiaSalida <- vuelosDeparted$pesoDiaSalida
####################vuelosDeparted2$diaSalida <- NULL

## Comprobacion de asignacion de grupo
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==21,]
#head(vuelosDeparted2)
#head(vuelosDeparted2[vuelosDeparted2$diaSalida == "15",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoDiaSalida)

###################################################################### 





## 6.16 horaSalida (PENDIENTE)
## 6.16.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","horaSalida"))
variables <- unique(df$horaSalida)
mediaHoraSalida <- mediasRetrasos(variables,df)
#boxplot(mediaHoraSalida$retrasoMedio)
#barplot(mediaHoraSalida$retrasoMedio, names.arg=mediaHoraSalida$codigo)
#summary(mediaHoraSalida$retrasoMedio)
#str(mediaHoraSalida)

## 6.16.2 Funcion para a?adir al dataframe una columna con los pesos
mediaHoraSalida$peso <- 0
mediaHoraSalida <- asignarPesos(mediaHoraSalida)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaHoraSalida)
#summary(mediaHoraSalida)


## 6.16.3 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaHoraSalida
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoHoraSalida <- asignarPesosDF(vuelosDeparted$horaSalida ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoHoraSalida)
#str(vuelosDeparted$pesoHoraSalida)


## 6.16.4 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoHoraSalida <- vuelosDeparted$pesoHoraSalida
###############vuelosDeparted2$horaSalida <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==46,]
#head(vuelosDeparted2)
#head(vuelosDeparted2[vuelosDeparted2$horaSalida == "23:00 - 23:29",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoHoraSalida)

###################################################################### 





## 6.17 mesLlegada (COMPLETADA)
## 6.17.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","mesLlegada"))
variables <- unique(df$mesLlegada)
mediaMesLlegada <- mediasRetrasos(variables,df)
#boxplot(mediaMesLlegada$retrasoMedio)
#barplot(mediaMesLlegada$retrasoMedio, names.arg=mediaMesLlegada$codigo)
#summary(mediaMesLlegada$retrasoMedio)
#str(mediaMesLlegada)


## 6.17.3 Funcion para a?adir al dataframe una columna con los pesos
mediaMesLlegada$peso <- 0
mediaMesLlegada <- asignarPesos(mediaMesLlegada)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaMesLlegada)
#summary(mediaMesLlegada)


## 6.17.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaMesLlegada
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoMesLlegada <- asignarPesosDF(vuelosDeparted$mesLlegada ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoMesLlegada)
#str(vuelosDeparted$pesoMesLlegada)


## 6.17.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoMesLlegada <- vuelosDeparted$pesoMesLlegada
#################vuelosDeparted2$mesLlegada <- NULL

## Comprobacion de asignacion de grupo
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==11,]
#head(vuelosDeparted2)
#head(vuelosDeparted2[vuelosDeparted2$mesLlegada == "1",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoMesLlegada)

###################################################################### 





## 6.18 anyoLlegada (COMPLETADA)
## No se hace analisis ya que solo tiene los valores 2015, 2016 y 2017




###################################################################### 


## 6.19 diaLlegada (COMPLETADA)
## 6.19.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","diaLlegada"))
variables <- unique(df$diaLlegada)
mediaDiaLlegada <- mediasRetrasos(variables,df)
#boxplot(mediaDiaLlegada$retrasoMedio)
#barplot(mediaDiaLlegada$retrasoMedio, names.arg=mediaDiaLlegada$codigo)
#summary(mediaDiaLlegada$retrasoMedio)
#str(mediaDiaLlegada)

## 6.19.3 Funcion para a?adir al dataframe una columna con los pesos
mediaDiaLlegada$peso <- 0
mediaDiaLlegada <- asignarPesos(mediaDiaLlegada)
## Comprobamos que se han indicado correctamente los grupos
#head(mediaDiaLlegada)
#summary(mediaDiaLlegada)

## 6.19.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaDiaLlegada
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoDiaLlegada <- asignarPesosDF(vuelosDeparted$diaLlegada ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoDiaLlegada)
#str(vuelosDeparted$pesoDiaLlegada)


## 6.19.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoDiaLlegada <- vuelosDeparted$pesoDiaLlegada
############vuelosDeparted2$diaLlegada <- NULL

## Comprobacion de asignacion de grupo
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==3,]
#head(vuelosDeparted2)
#head(vuelosDeparted2[vuelosDeparted2$diaLlegada == "21",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoDiaLlegada)

###################################################################### 





## 6.20 horaLlegada (COMPLETADA)
## 6.20.1. Calculamos el retraso medio. 
df <- subset(vuelosDeparted, select = c("arrival_delay","horaLlegada"))
variables <- unique(df$horaLlegada)
mediaHoraLlegada <- mediasRetrasos(variables,df)
#boxplot(mediaHoraLlegada$retrasoMedio)
#barplot(mediaHoraLlegada$retrasoMedio)
#summary(mediaHoraLlegada$retrasoMedio)
#str(mediaHoraLlegada)

## 6.20.3 Funcion para a?adir al dataframe una columna con los pesos
mediaHoraLlegada$peso <- 0
mediaHoraLlegada <- asignarPesos(mediaHoraLlegada)
## Comprobamos que se han indicado correctamente los pesos
#head(mediaHoraLlegada)
#summary(mediaHoraLlegada)

## 6.20.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el peso a los datos del dataframe
dfCodigoGrupo <- mediaHoraLlegada
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$pesoHoraLlegada <- asignarPesosDF(vuelosDeparted$horaLlegada ,dfCodigoGrupo)
#summary(vuelosDeparted$pesoHoraLlegada)
#str(vuelosDeparted$pesoHoraLlegada)


## 6.20.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$pesoHoraLlegada <- vuelosDeparted$pesoHoraLlegada
#######################vuelosDeparted2$horaLlegada <- NULL

## Comprobacion de asignacion de pesos
#dfCodigoGrupo
#head(vuelosDeparted2)
#dfCodigoGrupo[dfCodigoGrupo$peso==24,]
#head(vuelosDeparted2)
#head(vuelosDeparted2[vuelosDeparted2$horaLlegada == "17:00 - 17:29",],4)

#str(vuelosDeparted2)
#summary(vuelosDeparted2$pesoHoraLlegada)

###################################################################### 






## 6.21 diaSemanaSalida (COMPLETADA)
## 6.22.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSemanaSalida"))
variables <- unique(df$diaSemanaSalida)
mediaDiaSemSalida <- mediasRetrasos(variables,df)
#boxplot(mediaDiaSemSalida$retrasoMedio)
#barplot(mediaDiaSemSalida$retrasoMedio, names.arg=mediaDiaSemSalida$codigo)
#summary(mediaDiaSemSalida$retrasoMedio)
#str(mediaDiaSemSalida)

###################################################################### 






## 6.22 disSemanaLlegada (COMPLETADA)
## 6.22.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSemanaLlegada"))
variables <- unique(df$diaSemanaLlegada)
mediaDiaSemLlegada <- mediasRetrasos(variables,df)
#boxplot(mediaDiaSemLlegada$retrasoMedio)
#barplot(mediaDiaSemLlegada$retrasoMedio, names.arg=mediaDiaSemLlegada$codigo)
#summary(mediaDiaSemLlegada$retrasoMedio)
#str(mediaDiaSemLlegada)

###################################################################### 



str(vuelosDeparted)



#####################################################################################################
## 7. ELIMINAR VARIABLES CATEGORICAS ANALIZADAS Y SIN ANALIZAR QUE NO TENGAN SENTIDO MANTENER



# 7.1. Convertimos a factor las coordenadas geograficas
vuelosDeparted$board_lat <- as.factor(vuelosDeparted$board_lat)
vuelosDeparted$board_lon <- as.factor(vuelosDeparted$board_lon)
vuelosDeparted$off_lat <- as.factor(vuelosDeparted$off_lat)
vuelosDeparted$off_lon <- as.factor(vuelosDeparted$off_lon)

## 7.2 Como todos los vuelos tienen el valor Departed en la variable general_status_code, esta
## variable sera eliminada
vuelosDeparted$general_status_code <- NULL

## 7.3 Como todos los vuelos tienen el valor Y en la variable cabin_1_code, esta variable sera eliminada
vuelosDeparted$cabin_1_code <- NULL

## 7.4 Eliminamos las variables de fechas, ya que se han divido en rango de horas, dia, mes y a?o
vuelosDeparted$scheduled_time_of_arrival <- NULL
vuelosDeparted$actual_time_of_arrival <- NULL
vuelosDeparted$scheduled_time_of_departure <- NULL
vuelosDeparted$actual_time_of_departure <- NULL

## 7.5 Eliminamos la variable sched_blocktime, ya que la que realmente nos vale es act_blocktime
vuelosDeparted$sched_blocktime <- NULL

## 7.6 Eliminamos las variables anyo_salida y anyo_llegada, ya que es informacion irrelevante.
vuelosDeparted$anyoLlegada <- NULL
vuelosDeparted$anyoSalida <- NULL

## 7.7 Escribimos el dataframe con todas sus variables para poder analizarlo completamente y realizar graficas
write.csv('vuelosCompletoGraficas.csv',x = vuelosDeparted)

## 7.8 Eliminamos las variables categoricas analizadas
vuelosDeparted$airline_code <- NULL
vuelosDeparted$flight_number <- NULL
vuelosDeparted$board_point <- NULL
vuelosDeparted$board_country_code <- NULL
vuelosDeparted$off_point <- NULL
vuelosDeparted$off_country_code <- NULL
vuelosDeparted$aircraft_type <- NULL
vuelosDeparted$aircraft_registration_number <- NULL
vuelosDeparted$routing <- NULL
vuelosDeparted$horaLlegada <- NULL
vuelosDeparted$horaSalida <- NULL
vuelosDeparted$mesLlegada <- NULL
vuelosDeparted$mesSalida <- NULL
vuelosDeparted$diaLlegada <- NULL
vuelosDeparted$diaSalida <- NULL




## 8. Escribimos el dataframe resultante para reusarlo en la siguiente fase
write.csv('vuelosFinal.csv',x = vuelosDeparted)



## 9. Escribimos en la carpeta mediasFactores los dataframe que almacenan las medias para cada variable
## de tipo factor que ha sido analizada

setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM") ## ruta curro
#setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil
#setwd("C:/Users/sergi/Downloads/TFM-master (3)/TFM-master") ##RUTA SERGIO

dir.create("mediasFactores")

setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM/mediasFactores") ## ruta curro
#setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset/mediasFactores") ## ruta portatil
#setwd("C:/Users/sergi/Downloads/TFM-master (3)/TFM-master/mediasFactores") ##RUTA SERGIO


write.csv('mediaFlightNumber.csv',x = mediaRetrasosVuelo)
write.csv('mediaBoardPoint.csv',x = mediaPuntoEmbarque)
write.csv('mediaBoardLat.csv',x = mediaLatEmbarque)
write.csv('mediaBoardLon.csv',x = mediaBoardLon)
write.csv('mediaBoardCC.csv',x = mediaBoardCC)
write.csv('mediaOffPoint.csv',x = mediaOffPoint)
write.csv('mediaOffLat.csv',x = mediaOffLat)
write.csv('mediaOffLon.csv',x = mediaOffLon)
write.csv('mediaOffCC.csv',x = mediaOffCC)
write.csv('mediaAircraftType.csv',x = mediaTipoAvion)
write.csv('mediaAircraftRegistratioNumber.csv',x = mediaNumRegAvion)
write.csv('mediaRouting.csv',x = mediaRutas)
write.csv('mediaMesSalida.csv',x = mediaMesSalida)
write.csv('mediaDiaSalida.csv',x = mediaDiaSalida)
write.csv('mediaHoraSalida.csv',x = mediaHoraSalida)
write.csv('mediaMesLlegada.csv',x = mediaMesLlegada)
write.csv('mediaDiaLlegada.csv',x = mediaDiaLlegada)
write.csv('mediaHoraLlegada.csv',x = mediaHoraLlegada)
write.csv('mediaDiaSemanaSalida.csv',x = mediaDiaSemSalida)
write.csv('mediaDiaSemanaLlegada.csv',x = mediaDiaSemLlegada)



