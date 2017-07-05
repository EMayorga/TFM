
## Archivo donde se pintaran graficas de las variables del dataset con el fin de analizarlas.

setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM") ## ruta curro
#setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil


## Apertura del dataset
vuelos <- read.table("vuelosDeparted.csv", header = T, sep = ",")

str(vuelos)

## Eliminamos variables creadas al guardar el fichero
vuelos$X <- NULL

str(vuelos)
summary(vuelos)








## Graficas de variables
library(ggplot2)


#### VARIABLES CATEGORICAS 

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







# Flight_number
df <- subset(vuelos, select = c("arrival_delay","flight_number"))
variables <- unique(df$flight_number)
mediaFlightNumber <- mediasRetrasos(variables,df)

barplot(mediaFlightNumber$retrasoMedio, names.arg = "Retraso Medio Flight_Number")
boxplot(mediaFlightNumber$retrasoMedio)
summary(mediaFlightNumber$retrasoMedio)
barplot(mediaFlightNumber$numeroVuelos, names.arg = "Numero Vuelos Flight_Number")
boxplot(mediaFlightNumber$numeroVuelos)
summary(mediaFlightNumber$numeroVuelos)

## APARTADO1: ¿El retraso medio de un numero de vuelo es mayor cuantos mas vuelos haya realizado?

## Probamos con numeros de vuelos con mas de 300 vuelos y con numeros de vuelos con menos de 12 vuelos
FNMayor300 <- mediaFlightNumber[mediaFlightNumber$numeroVuelos>300,]
barplot(FNMayor300$retrasoMedio, names.arg = "Retraso Medio Numeros Vuelo más de 300 vuelos")

FNMenor12 <- mediaFlightNumber[mediaFlightNumber$numeroVuelos<12,]
barplot(FNMenor12$retrasoMedio, names.arg = "Retraso Medio Numeros Vuelo menos de 12 vuelos")

summary(FNMayor300$retrasoMedio)
summary(FNMenor12$retrasoMedio)

## Nos damos cuenta de que a mayor numeros de vuelos realizados menor es el retraso medio para la variable Flight_Number
## Los retrasos medios para variables con mas de 300 vuelos se situan entre -11 y 11 minutos
## Los retrasos medios para variables con menos de 12 vuelos se situan entre -35 y 50 minutos
## De lo obtenido en este apartado tambien podemos afirmar que el numero de vuelos no afecta en el retraso medio 





# BoardPoint
df <- subset(vuelos, select = c("arrival_delay","board_point"))
df$board_point <- as.factor(df$board_point)
variables <- unique(df$board_point)
mediaBoardPoint <- mediasRetrasos(variables,df)

barplot(mediaBoardPoint$retrasoMedio, names.arg = "Retraso Medio Board Point")
boxplot(mediaBoardPoint$retrasoMedio)
summary(mediaBoardPoint$retrasoMedio)
barplot(mediaBoardPoint$numeroVuelos, names.arg = "Numero Vuelos Board Point")
boxplot(mediaBoardPoint$numeroVuelos)
summary(mediaBoardPoint$numeroVuelos)

## Se observa que el aeropuerto LEU realiza la mayoria de los vuelos que aparecen en el dataset

## Observamos si el retraso medio esta determinado en funcion del nunmero de vuelos en cada aeropuerto de origen
## Obtenemos aeropuertos con mas de 1010 viajes y con menos de 15 viajes
BPmayor1010 <- mediaBoardPoint[mediaBoardPoint$numeroVuelos>1010,]
BPmenor15 <- mediaBoardPoint[mediaBoardPoint$numeroVuelos<15,]

barplot(BPmayor1010$retrasoMedio, names.arg = "Retraso Medio Aeropuertos mas de 1010 viajes")
boxplot(BPmayor1010$retrasoMedio)
summary(BPmayor1010$retrasoMedio)

barplot(BPmenor15$retrasoMedio, names.arg = "Retraso Medio Aeropuertos menos de 15 viajes")
boxplot(BPmenor15$retrasoMedio)
summary(BPmenor15$retrasoMedio)

## Al igual que en el apartado anterior podemos determinar que cuantos mas viajes menor es el retraso medio




# BoardLat
df <- subset(vuelos, select = c("arrival_delay","board_lat"))
variables <- unique(df$board_lat)
mediaBoardLat <- mediasRetrasos(variables,df)

barplot(mediaBoardLat$retrasoMedio, names.arg = "Retraso Medio Board Lat")
boxplot(mediaBoardLat$retrasoMedio)
summary(mediaBoardLat$retrasoMedio)
barplot(mediaBoardLat$numeroVuelos, names.arg = "Numero Vuelos Board Lat")
boxplot(mediaBoardLat$numeroVuelos)
summary(mediaBoardLat$numeroVuelos)

## Se observa que el aeropuerto LEU realiza la mayoria de los vuelos que aparecen en el dataset

## Observamos si el retraso medio esta determinado en funcion del nunmero de vuelos en cada aeropuerto de origen
## Obtenemos aeropuertos con mas de 1010 viajes y con menos de 15 viajes
## Los datos observamos son similares a Boart_point, esto es correcto ya que Board_point indica el nombre del aeropuerto
## y las variables board_lat y board_lon determinan su latitud y su longitud. Por lo tanto estas variables deben estar
## correlacionadas

summary(mediaBoardLat$retrasoMedio)
summary(mediaBoardPoint$retrasoMedio)

summary(mediaBoardLat$numeroVuelos)
summary(mediaBoardPoint$numeroVuelos)





# BoardLon
df <- subset(vuelos, select = c("arrival_delay","board_lon"))
variables <- unique(df$board_lon)
mediaBoardLon <- mediasRetrasos(variables,df)

barplot(mediaBoardLon$retrasoMedio, names.arg = "Retraso Medio Board Lon")
boxplot(mediaBoardLon$retrasoMedio)
summary(mediaBoardLon$retrasoMedio)
barplot(mediaBoardLon$numeroVuelos, names.arg = "Numero Vuelos Board Lon")
boxplot(mediaBoardLon$numeroVuelos)
summary(mediaBoardLon$numeroVuelos)

## Esta variable posee la misma informacion que las dos variables anteriores
summary(mediaBoardLon$retrasoMedio)
summary(mediaBoardLat$retrasoMedio)
summary(mediaBoardPoint$retrasoMedio)

summary(mediaBoardLon$numeroVuelos)
summary(mediaBoardLat$numeroVuelos)
summary(mediaBoardPoint$numeroVuelos)





# BoardCountryCode  
df <- subset(vuelos, select = c("arrival_delay","board_country_code"))
variables <- unique(df$board_country_code)
mediaBoardCC <- mediasRetrasos(variables,df)


barplot(mediaBoardCC$retrasoMedio, names.arg = "Retraso Medio Board Country Code")
boxplot(mediaBoardCC$retrasoMedio)
summary(mediaBoardCC$retrasoMedio)
barplot(mediaBoardCC$numeroVuelos, names.arg = "Numero Vuelos Board Country Code")
boxplot(mediaBoardCC$numeroVuelos)
summary(mediaBoardCC$numeroVuelos)


## Comprobamos que codigo de pais tiene un retraso medio mayor y menor
mediaBoardCC[mediaBoardCC$retrasoMedio>28,]
mediaBoardCC[mediaBoardCC$retrasoMedio<(-21),]





  
# OffPoint 
df <- subset(vuelos, select = c("arrival_delay","off_point"))
variables <- unique(df$off_point)
mediaOffPoint <- mediasRetrasos(variables,df)


barplot(mediaOffPoint$retrasoMedio, names.arg = "Retraso Medio Off Point")
boxplot(mediaOffPoint$retrasoMedio)
summary(mediaOffPoint$retrasoMedio)
barplot(mediaOffPoint$numeroVuelos, names.arg = "Numero Vuelos Off Point")
boxplot(mediaOffPoint$numeroVuelos)
summary(mediaOffPoint$numeroVuelos)

## Se vuelve a observar que el aeropuerto LEU es el que mas registros posee
mediaOffPoint[mediaOffPoint$numeroVuelos==max(mediaOffPoint$numeroVuelos),]

## Al igual que las variables Board_point, board_lat y board_lon, ocurre lo mismo con las variables off_point, off_lat
## y off_lon. Poseen la misma informacion



# OffLat
df <- subset(vuelos, select = c("arrival_delay","off_lat"))
variables <- unique(df$off_lat)
mediaOffLat <- mediasRetrasos(variables,df)

summary(mediaOffPoint$retrasoMedio)
summary(mediaOffLat$retrasoMedio)

summary(mediaOffPoint$numeroVuelos)
summary(mediaOffLat$numeroVuelos)

str(mediaOffPoint)
str(mediaOffLat)

## La informacion que posee esta variable es la misma que la variable off_point




# OffLon
df <- subset(vuelos, select = c("arrival_delay","off_lon"))
variables <- unique(df$off_lon)
mediaOffLon <- mediasRetrasos(variables,df)


summary(mediaOffPoint$retrasoMedio)
summary(mediaOffLat$retrasoMedio)
summary(mediaOffLon$retrasoMedio)

summary(mediaOffPoint$numeroVuelos)
summary(mediaOffLat$numeroVuelos)
summary(mediaOffLon$numeroVuelos)

str(mediaOffPoint)
str(mediaOffLat)
str(mediaOffLon)


## La informacion que posee esta variable es muy similar a las dos anteriores pero no es exacta.
## No obstante, las diferencias son muy escasas

barplot(mediaOffLon$retrasoMedio, names.arg = "Retraso Medio Off Lon")
boxplot(mediaOffLon$retrasoMedio)
summary(mediaOffLon$retrasoMedio)
barplot(mediaOffLon$numeroVuelos, names.arg = "Numero Vuelos Off Lon")
boxplot(mediaOffLon$numeroVuelos)
summary(mediaOffLon$numeroVuelos)




  
# OffCountryCode
df <- subset(vuelos, select = c("arrival_delay","off_country_code"))
variables <- unique(df$off_country_code)
mediaOffCC <- mediasRetrasos(variables,df)


barplot(mediaOffCC$retrasoMedio, names.arg = "Retraso Medio Off Country Code")
boxplot(mediaOffCC$retrasoMedio)
summary(mediaOffCC$retrasoMedio)
barplot(mediaOffCC$numeroVuelos, names.arg = "Numero Vuelos Off Country Code")
boxplot(mediaOffCC$numeroVuelos)
summary(mediaOffCC$numeroVuelos)

## La mayoria de vuelos tienen como pais de destino ES
mediaOffCC[mediaOffCC$numeroVuelos==max(mediaOffCC$numeroVuelos),]

## El pais con mayor retraso medio es SD y el pais con menor retraso medio es LT
mediaOffCC[mediaOffCC$retrasoMedio==max(mediaOffCC$retrasoMedio),]
mediaOffCC[mediaOffCC$retrasoMedio==min(mediaOffCC$retrasoMedio),]
  




# AircraftType
df <- subset(vuelos, select = c("arrival_delay","aircraft_type"))
variables <- unique(df$aircraft_type)
mediaAircraftType <- mediasRetrasos(variables,df)

barplot(mediaAircraftType$retrasoMedio, names.arg = "Retraso Medio Aircraft Type")
boxplot(mediaAircraftType$retrasoMedio)
summary(mediaAircraftType$retrasoMedio)
barplot(mediaAircraftType$numeroVuelos, names.arg = "Numero Vuelos Aircraft Type")
boxplot(mediaAircraftType$numeroVuelos)
summary(mediaAircraftType$numeroVuelos)


## El tipo de avion con mayor retraso medio es el 763
mediaAircraftType[mediaAircraftType$retrasoMedio==max(mediaAircraftType$retrasoMedio),]

## El tipo de avion con menor retraso medio es el 333
mediaAircraftType[mediaAircraftType$retrasoMedio==min(mediaAircraftType$retrasoMedio),]

## El tipo de avion que mas vuelos ha realizado es el 320
mediaAircraftType[mediaAircraftType$numeroVuelos==max(mediaAircraftType$numeroVuelos),]

## El tipo de avion que menos vuelos ha realizado es el 763, que coincide con el de mayor retraso medio
mediaAircraftType[mediaAircraftType$numeroVuelos==min(mediaAircraftType$numeroVuelos),]


ATmenor3121 <- mediaAircraftType[mediaAircraftType$numeroVuelos<3121,]
ATmayor23120 <- mediaAircraftType[mediaAircraftType$numeroVuelos>23120,]

barplot(ATmenor3121$retrasoMedio, names.arg = "Retraso Medio Aircraft Type menos de 3121 vuelos")
boxplot(ATmenor3121$retrasoMedio)
summary(ATmenor3121$retrasoMedio)  
ATmenor3121


barplot(ATmayor23120$retrasoMedio, names.arg = "Retraso Medio Aircraft Type mas de 23120 vuelos")
boxplot(ATmayor23120$retrasoMedio)
summary(ATmayor23120$retrasoMedio)  
ATmayor23120

## En este caso podemos determinar que el retraso medio es mayor cuanto menos vuelos ha realizado





# AircraftRegistrationNumber
df <- subset(vuelos, select = c("arrival_delay","aircraft_registration_number"))
variables <- unique(df$aircraft_registration_number)
mediaAircraftRegistratioNumber <- mediasRetrasos(variables,df)

barplot(mediaAircraftRegistratioNumber$retrasoMedio, names.arg = "Retraso Medio Aircraft Registration Number")
boxplot(mediaAircraftRegistratioNumber$retrasoMedio)
summary(mediaAircraftRegistratioNumber$retrasoMedio)  

barplot(mediaAircraftRegistratioNumber$numeroVuelos, names.arg = "Numero Vuelos Aircraft Registration Number")
boxplot(mediaAircraftRegistratioNumber$numeroVuelos)
summary(mediaAircraftRegistratioNumber$numeroVuelos)


mediaAircraftRegistratioNumber
## Visualizando el dataframe se puede observar que los numeros de registro de los aviones que han realizado menos 
## de 100 vuelos tienen un retraso medio elevado respecto de la media
mediaAircraftRegistratioNumber[mediaAircraftRegistratioNumber$numeroVuelos<100,]

## visualizando el retraso medio para aviones que tienen mas de 100 vuelos vemos que los retrasos se situan 
## entre -4 y 9 minutos
summary(mediaAircraftRegistratioNumber[mediaAircraftRegistratioNumber$numeroVuelos>100,])




  
# Routing
df <- subset(vuelos, select = c("arrival_delay","routing"))
variables <- unique(df$routing)
mediaRouting <- mediasRetrasos(variables,df)

barplot(mediaRouting$retrasoMedio, names.arg = "Retraso Medio Routing")
boxplot(mediaRouting$retrasoMedio)
summary(mediaRouting$retrasoMedio)  

barplot(mediaRouting$numeroVuelos, names.arg = "Numero Vuelos Routing")
boxplot(mediaRouting$numeroVuelos)
summary(mediaRouting$numeroVuelos)


## La ruta con mas retraso es ADB-LEU con 58 minutos
mediaRouting[mediaRouting$retrasoMedio==max(mediaRouting$retrasoMedio),]

## La ruta con menos retraso es AGF-LEU con -36 minutos
mediaRouting[mediaRouting$retrasoMedio==min(mediaRouting$retrasoMedio),]

## La ruta con mas viajes realizados es EOI-LEU con 5355 vuelos
mediaRouting[mediaRouting$numeroVuelos==max(mediaRouting$numeroVuelos),]

## Existen varias rutas que solo se han realizado 1 vez (minimo de vuelos)
mediaRouting[mediaRouting$numeroVuelos==min(mediaRouting$numeroVuelos),]





# MesSalida
df <- subset(vuelos, select = c("arrival_delay","mesSalida"))
variables <- unique(df$mesSalida)
mediaMesSalida <- mediasRetrasos(variables,df)

barplot(mediaMesSalida$retrasoMedio, names.arg = mediaMesSalida$codigo, main = "Retraso Mes Salida")
boxplot(mediaMesSalida$retrasoMedio)
summary(mediaMesSalida$retrasoMedio)  

barplot(mediaMesSalida$numeroVuelos, names.arg = mediaMesSalida$codigo, main = "Numero vuelos Mes Salida")
boxplot(mediaMesSalida$numeroVuelos)
summary(mediaMesSalida$numeroVuelos)


## Se puede observar que los meses 1, 2 y 12 son los que mas retraso medio indican.
## Estos meses corresponden a Enero, Febrero y Diciembre
## El mes 6 (Junio) es el que menos retraso medio indica

## Los meses 1,2 y 3 son los meses donde se registran mas vuelos.
## El mes 7 (Julio) es el mes donde menos vuelos se realizan

## Grafico de violin donde se muestran el retraso para cada mes en el que llega un vuelo
ggplot(vuelos,aes(as.factor(mesSalida), arrival_delay)) + geom_violin(scale = "count")


  
# DiaSalida
df <- subset(vuelos, select = c("arrival_delay","diaSalida"))
variables <- unique(df$diaSalida)
mediaDiaSalida <- mediasRetrasos(variables,df)


barplot(mediaDiaSalida$retrasoMedio, names.arg = mediaDiaSalida$codigo, main = "Retraso medio Dia Salida")
boxplot(mediaDiaSalida$retrasoMedio)
summary(mediaDiaSalida$retrasoMedio)  

barplot(mediaDiaSalida$numeroVuelos, names.arg = mediaDiaSalida$codigo, main = "Numero vuelos Dia Salida")
boxplot(mediaDiaSalida$numeroVuelos)
summary(mediaDiaSalida$numeroVuelos)

## El dia de salida con mayor retraso medio es el dia 8
mediaDiaSalida[mediaDiaSalida$retrasoMedio==max(mediaDiaSalida$retrasoMedio),]

## El dia de salida con un menor retraso medio es el dia 22
mediaDiaSalida[mediaDiaSalida$retrasoMedio==min(mediaDiaSalida$retrasoMedio),]

## El dia de salida donde mas vuelos se han realizado es el dia 8
mediaDiaSalida[mediaDiaSalida$numeroVuelos==max(mediaDiaSalida$numeroVuelos),]

## El dia de salida donde menos vuelos se han realizado es el dia 31
mediaDiaSalida[mediaDiaSalida$numeroVuelos==min(mediaDiaSalida$numeroVuelos),]






# HoraSalida 
df <- subset(vuelos, select = c("arrival_delay","horaSalida"))
variables <- unique(df$horaSalida)
mediaHoraSalida <- mediasRetrasos(variables,df)


barplot(mediaHoraSalida$retrasoMedio, names.arg = mediaHoraSalida$codigo, main = "Retraso Hora Salida")
boxplot(mediaHoraSalida$retrasoMedio)
summary(mediaHoraSalida$retrasoMedio)  

barplot(mediaHoraSalida$numeroVuelos, names.arg = mediaHoraSalida$codigo, main = "Numero vuelos Hora Salida")
boxplot(mediaHoraSalida$numeroVuelos)
summary(mediaHoraSalida$numeroVuelos)


## La hora con mayor retraso medio de los vuelos es de 0:00 - 0:29
mediaHoraSalida[mediaHoraSalida$retrasoMedio==max(mediaHoraSalida$retrasoMedio),]

## La hora con menor retraso medio de los vuelos es de 22:00 - 22:29
mediaHoraSalida[mediaHoraSalida$retrasoMedio==min(mediaHoraSalida$retrasoMedio),]

## La hora donde se realizan mas vuelos es de 15:00 - 15:29
mediaHoraSalida[mediaHoraSalida$numeroVuelos==max(mediaHoraSalida$numeroVuelos),]

## La hora donde se realizan menos vuelos es de 1:30 - 1:59
mediaHoraSalida[mediaHoraSalida$numeroVuelos==min(mediaHoraSalida$numeroVuelos),]



  

# MesLlegada
df <- subset(vuelos, select = c("arrival_delay","mesLlegada"))
variables <- unique(df$mesLlegada)
mediaMesLlegada <- mediasRetrasos(variables,df)

barplot(mediaMesLlegada$retrasoMedio, names.arg = mediaMesLlegada$codigo, main = "Retraso Mes Llegada")
boxplot(mediaMesLlegada$retrasoMedio)
summary(mediaMesLlegada$retrasoMedio)  

barplot(mediaMesLlegada$numeroVuelos, names.arg = mediaMesLlegada$codigo, main = "Numero vuelos Mes Llegada")
boxplot(mediaMesLlegada$numeroVuelos)
summary(mediaMesLlegada$numeroVuelos)


## Se puede observar que los meses 1, 2 y 12 son los que mas retraso medio indican.
## Estos meses corresponden a Enero, Febrero y Diciembre
## El mes 6 (Junio) es el que menos retraso medio indica

## Los meses 1,2 y 3 son los meses donde se registran mas vuelos.
## El mes 7 (Julio) es el mes donde menos vuelos se realizan

## Estos datos coinciden con los datos de la variable MesSalida

## Grafico de violin donde se muestran el retraso para cada mes en el que llega un vuelo
ggplot(vuelos,aes(as.factor(mesLlegada), arrival_delay)) + geom_violin(scale = "count")



  
# DiaLlegada
df <- subset(vuelos, select = c("arrival_delay","diaLlegada"))
variables <- unique(df$diaLlegada)
mediaDiaLlegada <- mediasRetrasos(variables,df)

barplot(mediaDiaLlegada$retrasoMedio, names.arg = mediaDiaLlegada$codigo, main = "Retraso medio Dia Llegada")
boxplot(mediaDiaLlegada$retrasoMedio)
summary(mediaDiaLlegada$retrasoMedio)  

barplot(mediaDiaLlegada$numeroVuelos, names.arg = mediaDiaLlegada$codigo, main = "Numero vuelos Dia Llegada")
boxplot(mediaDiaLlegada$numeroVuelos)
summary(mediaDiaLlegada$numeroVuelos)

## El dia de salida con mayor retraso medio es el dia 8
mediaDiaLlegada[mediaDiaLlegada$retrasoMedio==max(mediaDiaLlegada$retrasoMedio),]

## El dia de salida con un menor retraso medio es el dia 22
mediaDiaLlegada[mediaDiaLlegada$retrasoMedio==min(mediaDiaLlegada$retrasoMedio),]

## El dia de salida donde mas vuelos se han realizado es el dia 8
mediaDiaLlegada[mediaDiaLlegada$numeroVuelos==max(mediaDiaLlegada$numeroVuelos),]

## El dia de salida donde menos vuelos se han realizado es el dia 31
mediaDiaLlegada[mediaDiaLlegada$numeroVuelos==min(mediaDiaLlegada$numeroVuelos),]

## Estos datos coinciden con los de la variable diaSalida




# HoraLlegada
df <- subset(vuelos, select = c("arrival_delay","horaLlegada"))
variables <- unique(df$horaLlegada)
mediaHoraLlegada <- mediasRetrasos(variables,df)

barplot(mediaHoraLlegada$retrasoMedio, names.arg = mediaHoraLlegada$codigo, main = "Retraso Hora Llegada")
boxplot(mediaHoraLlegada$retrasoMedio)
summary(mediaHoraLlegada$retrasoMedio)  

barplot(mediaHoraLlegada$numeroVuelos, names.arg = mediaHoraLlegada$codigo, main = "Numero vuelos Hora Llegada")
boxplot(mediaHoraLlegada$numeroVuelos)
summary(mediaHoraLlegada$numeroVuelos)


## La hora con mayor retraso medio de los vuelos es de 2:00 - 2:29
mediaHoraLlegada[mediaHoraLlegada$retrasoMedio==max(mediaHoraLlegada$retrasoMedio),]

## La hora con menor retraso medio de los vuelos es de 6:00 - 6:29
mediaHoraLlegada[mediaHoraLlegada$retrasoMedio==min(mediaHoraLlegada$retrasoMedio),]

## La hora donde se realizan mas vuelos es de 18:00 - 18:29
mediaHoraLlegada[mediaHoraLlegada$numeroVuelos==max(mediaHoraLlegada$numeroVuelos),]

## La hora donde se realizan menos vuelos son dos: de 2:00 - 2:29 y de 4:00 - 4:29
mediaHoraLlegada[mediaHoraLlegada$numeroVuelos==min(mediaHoraLlegada$numeroVuelos),]




  
# DiaSemanaSalida
df <- subset(vuelos, select = c("arrival_delay","diaSemanaSalida"))
variables <- unique(df$diaSemanaSalida)  
mediaDiaSemanaSalida <- mediasRetrasos(variables,df)

barplot(mediaDiaSemanaSalida$retrasoMedio, names.arg = mediaDiaSemanaSalida$codigo, main = "Retraso Dia Semana Salida")
boxplot(mediaDiaSemanaSalida$retrasoMedio)
summary(mediaDiaSemanaSalida$retrasoMedio)  

barplot(mediaDiaSemanaSalida$numeroVuelos, names.arg = mediaDiaSemanaSalida$codigo, main = "Numero vuelos Dia Semana Salida")
boxplot(mediaDiaSemanaSalida$numeroVuelos)
summary(mediaDiaSemanaSalida$numeroVuelos)

## El dia de la semana de salida con mayor retraso medio es el viernes
mediaDiaSemanaSalida[mediaDiaSemanaSalida$retrasoMedio==max(mediaDiaSemanaSalida$retrasoMedio),]

## El dia de la semana de salida con menor retraso medio es el sabado
mediaDiaSemanaSalida[mediaDiaSemanaSalida$retrasoMedio==min(mediaDiaSemanaSalida$retrasoMedio),]

## El dia de la semana de salida con mayor numero de vuelos es el jueves
mediaDiaSemanaSalida[mediaDiaSemanaSalida$numeroVuelos==max(mediaDiaSemanaSalida$numeroVuelos),]

## El dia de la semana de salida con menor numero de vuelos es el sabado
mediaDiaSemanaSalida[mediaDiaSemanaSalida$numeroVuelos==min(mediaDiaSemanaSalida$numeroVuelos),]

## Grafico de violin donde se muestran el retraso para cada dia de la semana de Salida
ggplot(vuelos,aes(diaSemanaSalida, arrival_delay)) + geom_violin(scale = "count")




# DiaSemanaLlegada
df <- subset(vuelos, select = c("arrival_delay","diaSemanaLlegada"))
variables <- unique(df$diaSemanaLlegada)
mediaDiaSemanaLlegada <- mediasRetrasos(variables,df)

barplot(mediaDiaSemanaLlegada$retrasoMedio, names.arg = mediaDiaSemanaLlegada$codigo, main = "Retraso Dia Semana Llegada")
boxplot(mediaDiaSemanaLlegada$retrasoMedio)
summary(mediaDiaSemanaLlegada$retrasoMedio)  

barplot(mediaDiaSemanaLlegada$numeroVuelos, names.arg = mediaDiaSemanaLlegada$codigo, main = "Numero vuelos Dia Semana Llegada")
boxplot(mediaDiaSemanaLlegada$numeroVuelos)
summary(mediaDiaSemanaLlegada$numeroVuelos)

## El dia de la semana de salida con mayor retraso medio es el viernes
mediaDiaSemanaLlegada[mediaDiaSemanaLlegada$retrasoMedio==max(mediaDiaSemanaLlegada$retrasoMedio),]

## El dia de la semana de salida con menor retraso medio es el sabado
mediaDiaSemanaLlegada[mediaDiaSemanaLlegada$retrasoMedio==min(mediaDiaSemanaLlegada$retrasoMedio),]

## El dia de la semana de salida con mayor numero de vuelos es el lunes
mediaDiaSemanaLlegada[mediaDiaSemanaLlegada$numeroVuelos==max(mediaDiaSemanaLlegada$numeroVuelos),]

## El dia de la semana de salida con menor numero de vuelos es el sabado
mediaDiaSemanaLlegada[mediaDiaSemanaLlegada$numeroVuelos==min(mediaDiaSemanaLlegada$numeroVuelos),]


## Grafico de violin donde se muestran el retraso para cada dia de la semana de Llegada
ggplot(vuelos,aes(diaSemanaLlegada, arrival_delay)) + geom_violin(scale = "count")




str(vuelos)


# Variables numericas
## graficas de retraso en base a variables numericas

ggplot(vuelos, aes(x = distance, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = departure_delay, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = act_blocktime, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = cabin_1_fitted_configuration, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = cabin_1_saleable, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = cabin_1_pax_boarded, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = cabin_1_rpk, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = cabin_1_ask, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = total_rpk, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = total_ask, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = load_factor, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = total_pax, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = total_no_shows, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = total_cabin_crew, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = total_technical_crew, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = total_baggage_weight, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelos, aes(x = number_of_baggage_pieces, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

## De los graficos anteriores se puede observar que �nicamente existe correlacion con la variable
## arrival_delay por medio de la variable departure_delay