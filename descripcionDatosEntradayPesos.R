#####  TFM

##En esta ruta est? el script que nos ha enviado Israel por correo 
##setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM") ## ruta curro
setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil
#setwd("~/GitHub/TFM") ##RUTA SERGIO


## Apertura del dataset
vuelos <- read.table("operations_leg.csv", header = T, sep = "^")

str(vuelos)


## 1. Primera visualizacion de los datos
#summary(vuelos)

## 2. Eliminamos variables que no contienen informacion
vuelos$arrival_date <- NULL
vuelos$cabin_3_code <- NULL
vuelos$cabin_3_fitted_configuration <- NULL
vuelos$cabin_3_saleable <- NULL
vuelos$cabin_3_pax_boarded <- NULL
vuelos$cabin_3_rpk <- NULL
vuelos$cabin_3_ask <- NULL
vuelos$cabin_4_code <- NULL
vuelos$cabin_4_fitted_configuration <- NULL
vuelos$cabin_4_saleable <- NULL
vuelos$cabin_4_pax_boarded <- NULL
vuelos$cabin_4_rpk <- NULL
vuelos$cabin_4_ask <- NULL

#summary(vuelos)


## Nos centraremos en la variable "general_status_code" .
#vuelosCancelled <- vuelos[vuelos$general_status_code=="Cancelled",]   ## 1601 registros
vuelosDeparted <- vuelos[vuelos$general_status_code=="Departed",]     ## 220247 registros
#vuelosLocked <- vuelos[vuelos$general_status_code=="Locked",]         ## 3 registros
#vuelosOpen <- vuelos[vuelos$general_status_code=="Open",]             ## 154 registros
#vuelosSuspended <- vuelos[vuelos$general_status_code=="Suspended",]   ## 7 registros

## 2.1 Analizamos cada dataframe para ver si tiene sentido incluirlo en el estudio
## 2.1.1 vuelosCancelled
#str(vuelosCancelled)
#summary(vuelosCancelled)

## Para este caso, las horas de salida y de llegada se encuentran vacias en la mayor parte de sus datos
library(lubridate)
#vuelosCancelled$scheduled_time_of_departure <- ymd_hms(vuelosCancelled$scheduled_time_of_departure)
#vuelosCancelled$estimated_time_of_departure <- ymd_hms(vuelosCancelled$estimated_time_of_departure)
#vuelosCancelled$actual_time_of_departure <- ymd_hms(vuelosCancelled$actual_time_of_departure)
#vuelosCancelled$scheduled_time_of_arrival <- ymd_hms(vuelosCancelled$scheduled_time_of_arrival)
#vuelosCancelled$estimated_time_of_arrival <- ymd_hms(vuelosCancelled$estimated_time_of_arrival)
#vuelosCancelled$actual_time_of_arrival <- ymd_hms(vuelosCancelled$actual_time_of_arrival)
#summary(vuelosCancelled)



## Observamos que las fechas reales de salida y de llegada no estan indicadas, por lo que no es relevante para el estudio

## 2.2.2 vuelosLocked
#str(vuelosLocked)
#summary(vuelosLocked)

## Este DF tiene 3 registros. Ninguno de ellos tiene fechas indicadas de salida y llegada, por lo que no es relevante para el estudio

## 2.2.3 vuelosOpen
#str(vuelosOpen)
#summary(vuelosOpen)

## Este DF tiene 154 registros. Ninguno de ellos tiene fechas indicadas de salida y llegada, por lo que no es relevante para el estudio

## 2.2.4 vuelosSuspended
#str(vuelosSuspended)
#summary(vuelosSuspended)

## Este DF tiene 7 registros. Ninguno de ellos tiene fechas indicadas de salida y llegada, por lo que no es relevante para el estudio

## 2.2.5 vuelosDeparted
#str(vuelosDeparted)
#summary(vuelosDeparted)

vuelosDeparted$scheduled_time_of_departure <- ymd_hms(vuelosDeparted$scheduled_time_of_departure)
vuelosDeparted$estimated_time_of_departure <- ymd_hms(vuelosDeparted$estimated_time_of_departure)
vuelosDeparted$actual_time_of_departure <- ymd_hms(vuelosDeparted$actual_time_of_departure)
vuelosDeparted$scheduled_time_of_arrival <- ymd_hms(vuelosDeparted$scheduled_time_of_arrival)
vuelosDeparted$estimated_time_of_arrival <- ymd_hms(vuelosDeparted$estimated_time_of_arrival)
vuelosDeparted$actual_time_of_arrival <- ymd_hms(vuelosDeparted$actual_time_of_arrival)


#summary(vuelosDeparted)

## En este DF se encuentran los datos que queremos estudiar, por lo tanto utilizaremos "vuelosDeparted"


## 3. Eliminamos variables innecesarias del DF
vuelosDeparted$snapshot_date <- NULL ## La fecha de captura de datos es irrelevante para el estudio
vuelosDeparted$snapshot_time <- NULL ## La hora de captura de datos es irrelevante para el estudio
vuelosDeparted$estimated_time_of_departure <- NULL  ## La fecha estimada de salida es irrelevante para el estudio
vuelosDeparted$estimated_time_of_arrival <- NULL    ## La fecha estimada de llegada es irrelevante para el estudio
vuelosDeparted$est_blocktime <- NULL  ## El tiempo de vuelo estimado es irrelevante para el estudio



## Una vez tenemos los datos que queremos estudiar, realizamos un analisis y transformacion de variables si fuera necesario
#str(vuelosDeparted)
## Se observa que hay variables que deben ser transformadas.

## 4. Transformacion de datos

### 4.1 flight_number
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$flight_number)
#summary(vuelosDeparted$flight_number)

### Esta variable esta guardada como entero. Al ser un numero de vuelo lo transformamos a factor
vuelosDeparted$flight_number <- as.factor(vuelosDeparted$flight_number)

#options(max.print=999999)  ### incrementar la salida del summary
#summary(vuelosDeparted$flight_number, maxsum = 1100)

#str(vuelosDeparted$flight_number)
#unique(vuelosDeparted$flight_number)  ## 1045 vuelos distintos
#table(vuelosDeparted$flight_number)




### 4.2 flight_date
## (COMPLETADA)
###############################################################################################

## Comprobamos la necesidad de esta variable
#fechasVuelos <- subset(vuelosDeparted, select = c("flight_date","actual_time_of_departure","actual_time_of_arrival", "act_blocktime", "routing"))

#fechasVuelos$fecha <- as.Date(fechasVuelos$actual_time_of_departure)
#str(fechasVuelos)

#fechasVuelos$flight_date <- as.Date(fechasVuelos$flight_date)

#head(fechasVuelos,20)
#tail(fechasVuelos,20)

## Comprobamos si alguna fecha no coincide
#fechaIncorrecta <- fechasVuelos[fechasVuelos$flight_date!=fechasVuelos$fecha,]

#str(fechaIncorrecta)  ## Existen 432 fechas de vuelos que no coinciden con las fechas reales de salida
#head(fechaIncorrecta)
#### Existen fechas de vuelo que no corresponden a las fechas reales de salida

## Comprobamos que la variable "actual_time_of_departure" no tiene NAs
#summary(vuelosDeparted$actual_time_of_departure)

## Eliminamos del DF la variable flight_date.
## Aunque existen fechas que no coinciden, nos guiamos por la variable actual_time_of_departure para determinar 
## la fecha de salida de los vuelos
vuelosDeparted$flight_date <- NULL

#summary(vuelosDeparted)




### 4.3 board_point 
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$board_point)
#summary(vuelosDeparted$board_point, maxsum = 160)
#table(vuelosDeparted$board_point)

### Esta variable no contiene NAs y se almacena como factor.
### La analizaremos mas adelante





### 4.4 board_lat
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$board_lat)
#summary(vuelosDeparted$board_lat)

### Esta variable no contiene NAs y se almacena como numeric, la pasamos a factor
### y la analizaremos mas adelante
vuelosDeparted$board_lat <- as.factor(vuelosDeparted$board_lat)





### 4.5 board_lon
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$board_lon)
#summary(vuelosDeparted$board_lon)

### Esta variable no contiene NAs y se almacena como numeric, la pasamos a factor
### y la analizaremos mas adelante
vuelosDeparted$board_lon <- as.factor(vuelosDeparted$board_lon)





### 4.6 board_country_code ( y off_country_code )
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$board_country_code)
#summary(vuelosDeparted$board_country_code)

### Variable almacenada como factor
### Existen NAs. Comprobamos la latitud y longitud de los NAs

### 4.6.1 Dataframe de codigos de paises de salida con sus latitudes y longitudes
#vuelosCodeLatLonBoard <- subset(vuelosDeparted, select=c("board_country_code", "board_lat", "board_lon"))
#vuelosCodeLatLonBoard <- unique(vuelosCodeLatLonBoard)

#vuelosCodeLatLonBoard[is.na(vuelosCodeLatLonBoard$board_country_code)==TRUE,]
### se observa que los NA tienen la misma latitud y longitud, por lo que se trata de un ?nico aeropuerto


### 4.6.2. Comprobamos si los datos de aeropuertos de llegada guardan estas latitudes
#vuelosCodeLatLonArrive <- subset(vuelosDeparted, select = c("off_country_code","off_lat","off_lon"))
#vuelosCodeLatLonArrive <- unique(vuelosCodeLatLonArrive)

#vuelosCodeLatLonArrive[is.na(vuelosCodeLatLonArrive$off_country_code)==TRUE,]
### Se observa que en los datos de llegadas tambien existen NA con los mismos valores para latitud y longitud 

### 4.6.3 Para salidas y llegadas de vuelos, si buscamos la ruta realizada en funcion de latitud y longitud 
### observamos que el codigo de aeropuerto corresponde a WDH
#unique(subset(vuelosDeparted, vuelosDeparted$board_lon==17.08323 & vuelosDeparted$board_lat==-22.55941, select = c("routing")))
#unique(subset(vuelosDeparted, vuelosDeparted$off_lon==17.08323 & vuelosDeparted$off_lat==-22.55941, select = c("routing")))

### Buscando en internet el codigo de aeropuerto encontramos varias paginas donde se indica
### que el codigo WDH corresponde a Namibia:
### http://www.mundocity.com/vuelos/aeropuertos/windhoek+wdh.html
### https://es.wikipedia.org/wiki/Aeropuerto_Internacional_de_Windhoek_Hosea_Kutako

### 4.6.4 Como el aeropuerto es de Namibia sustituiremos los NAs por NM.
### Comprobamos si existe el codigo de aeropuerto escogido en los aeropuertos de salida y de llegada
#vuelosCodeLatLonBoard[vuelosCodeLatLonBoard$board_country_code=="NM",]
#vuelosCodeLatLonArrive[vuelosCodeLatLonArrive$off_country_code=="NM",]

### 4.6.5 Sustituimos NAs por NM en los datos de salida y de llegada
#summary(vuelosDeparted$board_country_code)  ## NAs -> 826 valores
vuelosDeparted$board_country_code <- as.character(vuelosDeparted$board_country_code)
vuelosDeparted$board_country_code <- replace(vuelosDeparted$board_country_code, is.na(vuelosDeparted$board_country_code), "NM")
vuelosDeparted$board_country_code <- as.factor(vuelosDeparted$board_country_code)
#summary(vuelosDeparted$board_country_code)  ## NM -> 826 valores

#summary(vuelosDeparted$off_country_code)  ## NAs -> 812 valores
vuelosDeparted$off_country_code <- as.character(vuelosDeparted$off_country_code)
vuelosDeparted$off_country_code <- replace(vuelosDeparted$off_country_code, is.na(vuelosDeparted$off_country_code), "NM")
vuelosDeparted$off_country_code <- as.factor(vuelosDeparted$off_country_code)
#summary(vuelosDeparted$off_country_code)  ## NM -> 812 valores

## Esta variable se analizara mas adelante

#summary(vuelosDeparted)





### 4.7 departure_date
## (COMPLETADA)
###############################################################################################

### Comprobamos la necesidad de esta variable
#departure <- subset(vuelosDeparted, select = c("departure_date","actual_time_of_departure"))

#head(departure,10)
#tail(departure,10)

## Comprobamos si la variable "actual_time_of_departure" tiene algun NA
#summary(vuelosDeparted$actual_time_of_departure)
## No existen NAs en "actual_time_of_departure"

## obtenemos las fechas de la variable actual_time_of_departure
#departure$fechaReal <- as.Date(departure$actual_time_of_departure)

#str(departure)

## Buscamos fechas que no coincidan
#departure$departure_date <- as.Date(departure$departure_date)
#fechaErronea <- departure[departure$departure_date!=departure$fechaReal,]

#str(fechaErronea)
## Existen 385 fechas erroneas

## Como existen fechas erroneas eliminaremos la variable "departure_date". Utilizaremos la variable 
## "actual_time_of_departure" en su lugar
vuelosDeparted$departure_date <- NULL

#summary(vuelosDeparted)






### 4.8 off_point
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$off_point)
#table(vuelosDeparted$off_point)

### Esta variable no contiene NAs y esta almacenada como tipo factor.
### Se analizara mas adelante






### 4.9 off_lat
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$off_lat)
#summary(vuelosDeparted$off_lat)

### Variable que no contiene NAs y almacenada como tipo numeric. La convertimos a factor.
### La analizaremos mas adelante
vuelosDeparted$off_lat <- as.factor(vuelosDeparted$off_lat)






### 4.10 off_lon
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$off_lon)
#summary(vuelosDeparted$off_lon)

### Variable que no contiene NAs y almacenada como tipo numeric. La convertimos a factor.
### Esta variable se analizara mas adelante
vuelosDeparted$off_lon <- as.factor(vuelosDeparted$off_lon)






### 4.11 distance
## (COMPLETADA)
###############################################################################################
#str(vuelosDeparted$distance)
#summary(vuelosDeparted$distance)

### Esta variable no contiene NAs y se encuentra almacenado como int. No haremos cambios en este campo






### 4.12 scheduled_time_of_departure
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$scheduled_time_of_departure)
#summary(vuelosDeparted$scheduled_time_of_departure)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que
### se analizara mas adelante





### 4.13 actual_time_of_departure
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$actual_time_of_departure)
#summary(vuelosDeparted$actual_time_of_departure)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que 
### se analizara mas adelante 






### 4.14 scheduled_time_of_arrival
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$scheduled_time_of_arrival)
#summary(vuelosDeparted$scheduled_time_of_arrival)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que 
### se analizara mas adelante






### 4.15 actual_time_of_arrival  
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$actual_time_of_arrival)
#summary(vuelosDeparted$actual_time_of_arrival)

### Esta variable ya fue transformada a tipo Date pero contiene NAs, por lo que hay que determinar si es posible sustituir 
### los NAs por algun valor determinado en funcion de otras variables existentes

## 4.15.1
#vuelosFechaNula <- vuelosDeparted[is.na(vuelosDeparted$actual_time_of_arrival)==TRUE,]
#str(vuelosFechaNula)  ## 3770 vuelos con fecha nula

## 4.15.2 Para aquellos casos en los que la fecha actual de llegada es nula, utilizaremos la suma de la fecha programada
## de llegada mas el retraso de llegada para obtener una fecha real de llegada del vuelo
#vuelosDeparted2 <- vuelosDeparted
#vuelosDeparted2$actual_time_of_arrival2 <- vuelosDeparted2$scheduled_time_of_arrival+minutes(vuelosDeparted2$arrival_delay)

## Comprobamos que la fechas calculadas (programada + retraso de salida) coinciden con las fechas actuales que ya tenemos
#fechasIncorrectas <- vuelosDeparted2[vuelosDeparted2$actual_time_of_arrival!=vuelosDeparted2$actual_time_of_arrival2,]

#fechasIncorrectas <- subset(fechasIncorrectas, 
#                            select = c("scheduled_time_of_departure", "departure_delay", "actual_time_of_departure",
#                                       "scheduled_time_of_arrival","arrival_delay","actual_time_of_arrival","actual_time_of_arrival2",
#                                       "act_blocktime"))

#str(fechasIncorrectas)  ## 7669 fechas incorrectas con NAs en "actual_time_of_arrival"

## Eliminamos NAs
#fechasIncorrectas <- fechasIncorrectas[is.na(fechasIncorrectas$actual_time_of_arrival)==FALSE,]
#str(fechasIncorrectas)  ## 3899 fechas incorrectas sin NAs en actual_time_of_arrival
#head(fechasIncorrectas,1)

## 4.15.3 Al haber realizado estos pasos nos hemos dado cuenta de que NO TIENE SENTIDO calcular el tiempo
## actual de llegada en base al tiempo de llegada programado mas el retraso de salida, ya que puede haber 
## datos que no cumplan con este criterio, como por ejemplo el siguiente:
#head(fechasIncorrectas,1)
## Con este dato se observa lo siguiente:
## La suma de la hora planificada de salida mas el retraso de salida no corresponde con la hora real de salida.
## Lo mismo ocurre con la hora planificada de llegada y la hora real de llegada. Sin embargo, la diferencia de 
## tiempo entre ambas fechas coincide con el blocktime indicado.
## ESTE DATO ES PERFECTAMENTE VALIDO, pero si nos basamos en la suma correspondiente a la fecha planificada de salida 
## mas el retraso de salida y en la fecha planificada de llegada mas el retraso de llegada este dato no seria valido.
## Por lo tanto, no tiene sentido calcular fechas reales en base a fechas planificadas y retrasos



## 4.15.4 Debido a que es imposible calcular con certeza la fecha de llegada de vuelos en base a datos del dataset, 
## descartaremos aquellos registros cuya variable "actual_time_of_arrival" sea nula.
vuelosDeparted <- vuelosDeparted[is.na(vuelosDeparted$actual_time_of_arrival)==FALSE,]

#summary(vuelosDeparted)

## Esta variable sera analizara mas adelante





### 4.16 departure_delay
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$departure_delay)
#summary(vuelosDeparted$departure_delay)

## La variable no contiene NAs y se encuentra almacenada como int, por ahora no haremos modificaciones





### 4.17 arrival_delay 
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$arrival_delay)
#summary(vuelosDeparted$arrival_delay)

## La variable no contiene NAs y se encuentra almacenada como int, por ahora no haremos modificaciones





### 4.18 sched_blocktime
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$sched_blocktime)
#summary(vuelosDeparted$sched_blocktime)

## Este campo esta almacenado como int y no contiene NAs. De momento no se modificara






### 4.19 act_blocktime 
## (COMPLETADA)
## Tiempo de vuelo. Diferencia entre hora de llegada y hora de salida. Indicado en minutos
###############################################################################################

#str(vuelosDeparted$act_blocktime)
#summary(vuelosDeparted$act_blocktime)

## Dato almacenado como entero.
## No existen valores NAs
## Esta variable no se modifica


## Analisis de los valores negativos en esta variable
## 4.19.1 almacenamos en una nueva variable la diferencia entre la fecha de llegada y la fecha de salida
##vuelosDeparted2 <- vuelosDeparted
##vuelosDeparted2$BlocktimeNEW <- as.integer(
##                    difftime(vuelosDeparted2$actual_time_of_arrival, vuelosDeparted2$actual_time_of_departure, units = "mins"))

#head(vuelosDeparted2)

## Comprobamos si hay registros donde la nueva variable calculada (BlocktimeNEW) sea diferente a act_blocktime
#str(vuelosDeparted2)
##tiemposDiferentes <- vuelosDeparted2[vuelosDeparted2$act_blocktime!=vuelosDeparted2$BlocktimeNEW,]

#str(tiemposDiferentes)
#head(tiemposDiferentes)


##fechasRetrasos <- subset(tiemposDiferentes, 
##                select = c("actual_time_of_departure","actual_time_of_arrival",
##                           "act_blocktime","BlocktimeNEW","routing"))

#head(fechasRetrasos,5)

#table(fechasRetrasos$routing)

## Obtenemos diferentes rutas de ejemplo
## AMV-LEU      AMV +1            
## CNF-LEU      CNF -5

##fechasRetrasos$difTiempoMin <- fechasRetrasos$BlocktimeNEW - fechasRetrasos$act_blocktime

### AMV-LEU
##tiempoRuta <- fechasRetrasos[fechasRetrasos$routing=="AMV-LEU",]
#str(tiempoRuta)
#head(tiempoRuta, 54)


#unique(tiempoRuta$difTiempoMin)
## AMV es el aeropuerto de Amderma, en Rusia
## Este unique da como resultado -120 y -60. Estos valores indican las diferencias horarias para la ruta AMV-LEU
## que coinciden con el horario de verano y horario de invierno en europa. Es decir, en diferentes articulos como
## este (http://www.elmundo.es/elmundo/2011/02/08/ciencia/1297174335.html, de 2011) se indica que Rusia suprime el
## cambio horario, sin embargo la Union Europea lo mantiene y, por tanto, en invierno hay dos horas de diferencia 
## entre Rusia y Europa pero en verano solo hay 1 hora de diferencia
## Si utilizamos la ruta CNF-LEU ocurre lo mismo. Las diferencias encontradas son por los diferentes husos horarios
## y los cambios horarios establecidos localmente en verano e invierno


## Como se puede observar con la ruta anterior, los valores negativos son correctos ya que se obtienen en funcion
## de la zona horaria y los cambios horarios de cada pais







### 4.20 aircraft_type
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$aircraft_type)
#summary(vuelosDeparted$aircraft_type)

## Este campo no contiene NAs y esta almacenado como tipo factor. 
## Se estudiara mas adelante







### 4.21 aircraft_registration_number
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$aircraft_registration_number)
#summary(vuelosDeparted$aircraft_registration_number)

## Este campo no contiene NAs y esta almacenado como tipo factor. 
## Se estudiara mas adelante.






### 4.22 general_status_code
## (COMPLETADA)
###############################################################################################
## Este campo ya fue analizado







### 4.23 routing
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$routing)
#summary(vuelosDeparted$routing, maxsum = 357)

## Este campo se almacena como factor y no contiene NAs.
## Se estudiara mas adelante







### 4.24 cabin_1_code / cabin_2_code 
## (COMPLETADA)
###############################################################################################

## Por los correos tenemos que los codigos son los siguientes: 
### Y economy, W premium eco, J business, F first


#str(vuelosDeparted$cabin_1_code)
#summary(vuelosDeparted$cabin_1_code)

## Se almacena como factor, todos los datos de esta variable son Y (economy)

#str(vuelosDeparted$cabin_2_code)
#summary(vuelosDeparted$cabin_2_code)

## Se almacena como factor. Tiene 93506 registros vacios (que no NAs) y 122971 registros con J (business)

## Comprobamos los registros vacios
#cabin2Vacio <- vuelosDeparted[trimws(vuelosDeparted$cabin_2_code)=="",]
#head(cabin2Vacio)

## Comprobamos si algun registro con cabin_2_code vacio tiene valores almacenados en algun campo de cabin_2
#cabin2ask <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_ask)==FALSE,]
#cabin2saleable  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_saleable)==FALSE,]
#cabin2fitted_configuration  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_fitted_configuration)==FALSE,]
#cabin2pax_boarded  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_pax_boarded)==FALSE,]
#cabin2rpk  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_rpk)==FALSE,]
#cabin2ask  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_ask)==FALSE,]

#str(cabin2ask)
#str(cabin2saleable)
#str(cabin2fitted_configuration)
#str(cabin2pax_boarded)
#str(cabin2rpk)
#str(cabin2ask)

## No existen datos anomalos






### 4.25 cabin_1_fitted_configuration / cabin_2_fitted_configuration -> Numero de asientos
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$cabin_1_fitted_configuration)
#summary(vuelosDeparted$cabin_1_fitted_configuration)

## Esta variable se almacena como int y no contiene NAs.

#str(vuelosDeparted$cabin_2_fitted_configuration)
#summary(vuelosDeparted$cabin_2_fitted_configuration)

## Esta variable se almacena como int y tiene 93506 NAs, que coinciden con los registros vacios del
## campo "cabin_2_code".

## Comprobamos los registros vacios
#cabin2Vacio <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_fitted_configuration)==TRUE,]
#summary(cabin2Vacio)

## Estos datos coinciden con los datos de cabin_2_code. Todo OK.







### 4.26 cabin_1_saleable / cabin_2_saleable  -> numero de asientos en venta
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$cabin_1_saleable)
#summary(vuelosDeparted$cabin_1_saleable)

## No contiene NAs y se almacena como entero

#str(vuelosDeparted$cabin_2_saleable)
#summary(vuelosDeparted$cabin_2_saleable)

## Campo almacenado como entero y contiene 93547 NAs, Son mas NAs de los que aparecen en el campo anterior


## Estudiamos los NAs de esta variable
#cabinNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_saleable)==TRUE,]

#str(cabinNA)
#summary(cabinNA)
#head(cabinNA)

## Se observa que hay 41 registros con cabin_2_code = J, que son lo que hacen la diferencia de esta variable
## con respecto a los NAs existentes en cabin_2_code

#cabinJ <- cabinNA[cabinNA$cabin_2_code=="J",]

#str(cabinJ)
#summary(cabinJ)
#head(cabinJ)


## Estos 41 registros deben ser eliminados
vuelosDeparted <- vuelosDeparted[trimws(vuelosDeparted$cabin_2_code)=="" | 
                                   (vuelosDeparted$cabin_2_code=="J" & is.na(vuelosDeparted$cabin_2_saleable)==FALSE),]







### 4.27 cabin_1_pax_boarded / cabin_2_pax_boarded 
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$cabin_1_pax_boarded)
#summary(vuelosDeparted$cabin_1_pax_boarded)

## Campo almacenado como entero. Existen 3540 NAs

## Comprobacion de los NAs
#cabinPaxNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_1_pax_boarded)==TRUE,]

#str(cabinPaxNA)
#summary(cabinPaxNA)

## Las variables cabin_1_... y cabin_2_... son NAs. Eliminamos estos 3540 registros
vuelosDeparted <- vuelosDeparted[is.na(vuelosDeparted$cabin_1_pax_boarded)==FALSE,]

## cabin_2_pax_boarded

#str(vuelosDeparted$cabin_2_pax_boarded)
#summary(vuelosDeparted$cabin_2_pax_boarded)

## Campo almacenado como entero. Existen 89966 NAs 

## Obtenemos los NAs
#cabinPaxNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_pax_boarded)==TRUE,]

#summary(cabinPaxNA)
## Haciendo el summary existen 198 registros con el campo "cabin_2_code" = J
#cabinPaxNAJ <- cabinPaxNA[cabinPaxNA$cabin_2_code=="J",]

#summary(cabinPaxNAJ)

## eliminamos estos 198 registros, ya que no tiene datos en los campos cabin_2_...
vuelosDeparted <- vuelosDeparted[trimws(vuelosDeparted$cabin_2_code)=="" | 
                                   (vuelosDeparted$cabin_2_code=="J" & is.na(vuelosDeparted$cabin_2_pax_boarded)==FALSE),]

#summary(vuelosDeparted)






### 4.28 cabin_1_rpk / cabin_2_rpk  Beneficio en funcion de los pasajeros o unidad tipica para evaluar la demanda 
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$cabin_1_rpk)
#summary(vuelosDeparted$cabin_1_rpk)

## Campo almacenado como entero. No contiene NAs

#str(vuelosDeparted$cabin_2_rpk)
#summary(vuelosDeparted$cabin_2_rpk)

## Campo almacenado como entero. Existen 89966 NAs






### 4.29 cabin_1_ask / cabin_2_ask  -> unidad tipica para evaluar la oferta
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$cabin_1_ask)
#summary(vuelosDeparted$cabin_1_ask)

## Campo almacenado como int. No contiene NAs

#str(vuelosDeparted$cabin_2_ask)
#summary(vuelosDeparted$cabin_2_ask)

## Campo almacenado como int. Contiene 89966 NAs, que corresponden a los valores cabin_1... que no tienen cabin_2...






### 4.30 total_rpk
### (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$total_rpk)
#summary(vuelosDeparted$total_rpk)

## Campo almacenado como entero. No contiene NAs






### 4.31 total_ask
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$total_ask)
#summary(vuelosDeparted$total_ask)

## Campo almacenado como int. No existen NAs







### 4.32 load_factor
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$load_factor)
#summary(vuelosDeparted$load_factor)

## Campo almacenado como num. No existen NAs







### 4.33 total_pax
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$total_pax)
#summary(vuelosDeparted$total_pax)

## Campo almacenado como int. No existen NAs






### 4.34 total_no_shows
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$total_no_shows)
#summary(vuelosDeparted$total_no_shows)

## Campo almacenado como int. No existen NAs






### 4.35 total_cabin_crew 
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$total_cabin_crew)
#summary(vuelosDeparted$total_cabin_crew)

## Campo almacenado como int. No existen NAs







### 4.36 total_technical_crew
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$total_technical_crew)
#summary(vuelosDeparted$total_technical_crew)

## Campo almacenado como int. No existen NAs






### 4.37 total_baggage_weight
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$total_baggage_weight)
#summary(vuelosDeparted$total_baggage_weight)

## Campo almacenado como int. No existen NAs







### 4.38 number_of_baggage_pieces
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$number_of_baggage_pieces)
#summary(vuelosDeparted$number_of_baggage_pieces)

## Campo almacenado como int. No existen NAs







### 4.39 file_sequence_number
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$file_sequence_number)
#summary(vuelosDeparted$file_sequence_number)

## Campo almacenado como factor. No existen los valores 1, 2 y 3. Existen los valores P (220229)
## Al ser siempre el mismo valor la eliminamos del conjunto de datos

vuelosDeparted$file_sequence_number <- NULL




### RESULTADO DEL DATAFRAME TRAS LA LIMPIEZA DE SUS VARIABLES
#str(vuelosDeparted)   ## 212698 objetos   -> nuevo
#str(vuelos)           ## 222012 objetos   -> original






### 5. CREACION DE NUEVAS VARIABLES

## Segmentamos las fechas en a?os, mes, dia y hora
## 5.1. Mes de salida del vuelo
vuelosDeparted$mesSalida <- as.integer(month(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$mesSalida <- as.factor(vuelosDeparted$mesSalida)

## 5.2 a?o de salida del vuelo
vuelosDeparted$anyoSalida <- as.integer(year(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$anyoSalida <- as.factor(vuelosDeparted$anyoSalida)

## 5.3. Dia de salida del vuelo
vuelosDeparted$diaSalida <- as.integer(day(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$diaSalida <- as.factor(vuelosDeparted$diaSalida)

## 5.4. Hora de salida del vuelo
## Las horas las dividimos en intervalos de media hora, por ejemplo:
## Para un vuelo que sale a las 13:34, su intervalo de salida sera 13:30 - 13:59

## Funcion para determinar la hora de salida o llegada de un vuelo
obtenerHora <- function(vectorHoras){
  horas <- hour(vectorHoras)
  minutos <- minute(vectorHoras)
  res <- vector()
  
  for(i in 1:length(horas)){
    if (minutos[i] >= 30){
      res[i] = paste(paste(horas[i],"30", sep = ":"),paste(horas[i],"59", sep = ":"),sep = " - ")
    }else{
      res[i] = paste(paste(horas[i],"00", sep = ":"),paste(horas[i],"29", sep = ":"),sep = " - ")
    }
  }
  
  return(res)
}

vuelosDeparted$horaSalida <- obtenerHora(vuelosDeparted$actual_time_of_departure)
vuelosDeparted$horaSalida <- as.factor(vuelosDeparted$horaSalida)


## 5.5 Mes de llegada del vuelo
vuelosDeparted$mesLlegada <- as.integer(month(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$mesLlegada <- as.factor(vuelosDeparted$mesLlegada)

## 5.6 ano de llegada del vuelo
vuelosDeparted$anyoLlegada <- as.integer(year(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$anyoLlegada <- as.factor(vuelosDeparted$anyoLlegada)

## 5.7 Dia de llegada del vuelo
vuelosDeparted$diaLlegada <- as.integer(day(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$diaLlegada <- as.factor(vuelosDeparted$diaLlegada)

## 5.8 Hora de llegada del vuelo
vuelosDeparted$horaLlegada <- obtenerHora(vuelosDeparted$actual_time_of_arrival)
vuelosDeparted$horaLlegada <- as.factor(vuelosDeparted$horaLlegada)

## 5.9. Dia de la semana para la salida de los vuelos
vuelosDeparted$diaSemanaSalida <- weekdays(as.Date(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$diaSemanaSalida <- as.factor(vuelosDeparted$diaSemanaSalida)

## 5.10. Dia de la semana para la llegada de los vuelos
vuelosDeparted$diaSemanaLlegada <- weekdays(as.Date(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$diaSemanaLlegada <- as.factor(vuelosDeparted$diaSemanaLlegada)






## 6. Variables de tipo FACTOR
vuelosDeparted2 <- vuelosDeparted
## Ya que muchas de estas variables estan compuestas por demasiados valores como para analizarlos uno por uno
## decidimos agrupar los valores de estas variables en funcion del retraso medio para cada uno de ellos.
## Las agrupaciones se haran en base a los cuartiles 

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

## 7.1 Eliminamos las variables categoricas analizadas
vuelosDeparted$airline_code <- NULL
vuelosDeparted$flight_number <- NULL
vuelosDeparted$board_point <- NULL
vuelosDeparted$board_lat <- NULL
vuelosDeparted$board_lon <- NULL
vuelosDeparted$board_country_code <- NULL
vuelosDeparted$off_point <- NULL
vuelosDeparted$off_lat <- NULL
vuelosDeparted$off_lon <- NULL
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


str(vuelosDeparted)

## 7.7 Comprobar correlacion entre variables
## Existen varias variables dentro del modelo que pueden estar correlacionadas, por lo tanto las estudiaremos y 
## determinaremos si son necesarias.

#str(vuelosDeparted)
## 7.7.1 diaSalida VS diaLlegada y diaSalidaGroup VS diaLlegadaGroup
tablaDia <- table(vuelosDeparted$diaSalida, vuelosDeparted$diaLlegada)
tablaDia
plot(tablaDia, col = c("red", "blue"), main = "Dia Salida vs. Dia Llegada")
chisq.test(tablaDia)
## P-value indica que existe correlacion entre ambas variables
vuelosDeparted$diaLlegada <- NULL
vuelosDeparted$diaVuelo <- vuelosDeparted$diaSalida
vuelosDeparted$diaSalida <- NULL

tablaDiaGroup <- table(vuelosDeparted$diaSalidaGroup, vuelosDeparted$diaLlegadaGroup)
tablaDiaGroup
plot(tablaDiaGroup, col = c("red", "blue"), main = "Dia Salida Group vs. Dia Llegada Group")
chisq.test(tablaDiaGroup)
## P-Value indica que hay correlacion entre ambas variables
vuelosDeparted$diaLlegadaGroup <- NULL
vuelosDeparted$diaVueloGroup <- vuelosDeparted$diaSalidaGroup
vuelosDeparted$diaSalidaGroup <- NULL


## 7.7.2 MesSalida VS MesLlegada y MesSalidaGroup VS MesLlegadaGroup
tablaMes <- table(vuelosDeparted$mesSalida, vuelosDeparted$mesLlegada)
tablaMes
plot(tablaMes, col = c("red", "blue"), main = "Mes Salida vs. Mes Llegada")
chisq.test(tablaMes)
## En base al valor de P-value (menor que 0.05) determinamos que hay correlacion entre estas dos variables, por 
## lo que podemos eliminar una de ellas para realizar el estudio.
vuelosDeparted$mesLlegada <- NULL
vuelosDeparted$mesVuelo <- vuelosDeparted$mesSalida
vuelosDeparted$mesSalida <- NULL


tablaMesGroup <- table(vuelosDeparted$mesSalidaGroup, vuelosDeparted$mesLlegadaGroup)
tablaMesGroup
plot(tablaMesGroup, col = c("red", "blue"), main = "Mes Salida Group vs. Mes Llegada Group")
chisq.test(tablaMesGroup)
## El valor p-value indica que hay correlacion entre las dos variabels, por lo que eliminaremos una de ellas.
vuelosDeparted$mesLlegadaGroup <- NULL
vuelosDeparted$mesVueloGroup <- vuelosDeparted$mesSalidaGroup
vuelosDeparted$mesSalidaGroup <- NULL


## 7.7.3 diaSemanaSalida VS diaSemanaLlegada y 
tablaDiaSemana <- table(vuelosDeparted$diaSemanaSalida, vuelosDeparted$diaSemanaLlegada)
tablaDiaSemana
plot(tablaDiaSemana, col = c("red", "blue"), main = "Dia Salida  vs. Dia Llegada Group")
chisq.test(tablaDiaSemana)
## P-value indica que hay correlacion. Eliminaremos una de las variables
vuelosDeparted$diaSemanaLlegada <- NULL
vuelosDeparted$diaSemanaVuelo <- vuelosDeparted$diaSemanaSalida
vuelosDeparted$diaSemanaSalida <- NULL


## 7.7.4 
tabla <- table(vuelosDeparted$distance, vuelosDeparted$arrival_delay)
tabla
plot(tabla, col = c("red", "blue"), main = "Dia Salida  vs. Dia Llegada Group")
chisq.test(tabla, simulate.p.value = TRUE)








## 8. Escribimos el dataframe resultante para reusarlo en la siguiente fase
write.csv('vuelosDeparted.csv',x = vuelosDeparted)

str(vuelosDeparted)





