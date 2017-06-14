#####  TFM

## En esta ruta est? el script que nos ha enviado Israel por correo 
setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM") ## ruta curro
#setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil
#setwd("~/GitHub/TFM") ##RUTA SERGIO


## Apertura del dataset
vuelos <- read.table("operations_leg.csv", header = T, sep = "^")




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
vuelosCancelled <- vuelos[vuelos$general_status_code=="Cancelled",]   ## 1601 registros
vuelosDeparted <- vuelos[vuelos$general_status_code=="Departed",]     ## 220247 registros
vuelosLocked <- vuelos[vuelos$general_status_code=="Locked",]         ## 3 registros
vuelosOpen <- vuelos[vuelos$general_status_code=="Open",]             ## 154 registros
vuelosSuspended <- vuelos[vuelos$general_status_code=="Suspended",]   ## 7 registros

## 2.1 Analizamos cada dataframe para ver si tiene sentido incluirlo en el estudio
## 2.1.1 vuelosCancelled
#str(vuelosCancelled)
#summary(vuelosCancelled)

## Para este caso, las horas de salida y de llegada se encuentran vacias en la mayor parte de sus datos
library(lubridate)
vuelosCancelled$scheduled_time_of_departure <- ymd_hms(vuelosCancelled$scheduled_time_of_departure)
vuelosCancelled$estimated_time_of_departure <- ymd_hms(vuelosCancelled$estimated_time_of_departure)
vuelosCancelled$actual_time_of_departure <- ymd_hms(vuelosCancelled$actual_time_of_departure)
vuelosCancelled$scheduled_time_of_arrival <- ymd_hms(vuelosCancelled$scheduled_time_of_arrival)
vuelosCancelled$estimated_time_of_arrival <- ymd_hms(vuelosCancelled$estimated_time_of_arrival)
vuelosCancelled$actual_time_of_arrival <- ymd_hms(vuelosCancelled$actual_time_of_arrival)

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
##vuelosDeparted$est_blocktime <- NULL  ## El tiempo de vuelo estimado es irrelevante para el estudio



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

options(max.print=999999)  ### incrementar la salida del summary
#summary(vuelosDeparted$flight_number, maxsum = 1100)

#str(vuelosDeparted$flight_number)
#unique(vuelosDeparted$flight_number)  ## 1045 vuelos distintos
#table(vuelosDeparted$flight_number)

### 4.2 flight_date
## (COMPLETADA)
###############################################################################################

## Comprobamos la necesidad de esta variable
fechasVuelos <- subset(vuelosDeparted, select = c("flight_date","actual_time_of_departure","actual_time_of_arrival", "act_blocktime", "routing"))

fechasVuelos$fecha <- as.Date(fechasVuelos$actual_time_of_departure)
#str(fechasVuelos)

fechasVuelos$flight_date <- as.Date(fechasVuelos$flight_date)

#head(fechasVuelos,20)
#tail(fechasVuelos,20)

## Comprobamos si alguna fecha no coincide
fechaIncorrecta <- fechasVuelos[fechasVuelos$flight_date!=fechasVuelos$fecha,]

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

### Esta variable no contiene NAs y se almacena como factor, por lo que no la modificaremos



### 4.4 board_lat
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$board_lat)
#summary(vuelosDeparted$board_lat)

### Esta variable no contiene NAs y se almacena como numeric, la pasamos a factor
vuelosDeparted$board_lat <- as.factor(vuelosDeparted$board_lat)


### 4.5 board_lon
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$board_lon)
#summary(vuelosDeparted$board_lon)

### Esta variable no contiene NAs y se almacena como numeric, la pasamos a factor
vuelosDeparted$board_lon <- as.factor(vuelosDeparted$board_lon)


### 4.6 board_country_code ( y off_country_code )
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$board_country_code)
#summary(vuelosDeparted$board_country_code)

### Variable almacenada como factor
### Existen NAs. Comprobamos la latitud y longitud de los NAs

### 4.6.1 Dataframe de codigos de paises de salida con sus latitudes y longitudes
vuelosCodeLatLonBoard <- subset(vuelosDeparted, select=c("board_country_code", "board_lat", "board_lon"))
vuelosCodeLatLonBoard <- unique(vuelosCodeLatLonBoard)

vuelosCodeLatLonBoard[is.na(vuelosCodeLatLonBoard$board_country_code)==TRUE,]
### se observa que los NA tienen la misma latitud y longitud, por lo que se trata de un ?nico aeropuerto


### 4.6.2. Comprobamos si los datos de aeropuertos de llegada guardan estas latitudes
vuelosCodeLatLonArrive <- subset(vuelosDeparted, select = c("off_country_code","off_lat","off_lon"))
vuelosCodeLatLonArrive <- unique(vuelosCodeLatLonArrive)

vuelosCodeLatLonArrive[is.na(vuelosCodeLatLonArrive$off_country_code)==TRUE,]
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
vuelosCodeLatLonBoard[vuelosCodeLatLonBoard$board_country_code=="NM",]
vuelosCodeLatLonArrive[vuelosCodeLatLonArrive$off_country_code=="NM",]

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


#summary(vuelosDeparted)

### 4.7 departure_date
## (COMPLETADA)
###############################################################################################

### Comprobamos la necesidad de esta variable
departure <- subset(vuelosDeparted, select = c("departure_date","actual_time_of_departure"))

#head(departure,10)
#tail(departure,10)

## Comprobamos si la variable "actual_time_of_departure" tiene algun NA
#summary(vuelosDeparted$actual_time_of_departure)
## No existen NAs en "actual_time_of_departure"

## obtenemos las fechas de la variable actual_time_of_departure
departure$fechaReal <- as.Date(departure$actual_time_of_departure)

#str(departure)

## Buscamos fechas que no coincidan
departure$departure_date <- as.Date(departure$departure_date)
fechaErronea <- departure[departure$departure_date!=departure$fechaReal,]

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

### Esta variable no contiene NAs y esta almacenada como tipo factor, por lo tanto no se hacen modificaciones


### 4.9 off_lat
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$off_lat)
#summary(vuelosDeparted$off_lat)

### Variable que no contiene NAs y almacenada como tipo numeric. La convertimos a factor
vuelosDeparted$off_lat <- as.factor(vuelosDeparted$off_lat)


### 4.10 off_lon
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$off_lon)
#summary(vuelosDeparted$off_lon)

### Variable que no contiene NAs y almacenada como tipo numeric. La convertimos a factor
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

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que de momento no se modificara



### 4.13 actual_time_of_departure
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$actual_time_of_departure)
#summary(vuelosDeparted$actual_time_of_departure)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que de momento no se modificara




### 4.14 scheduled_time_of_arrival
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$scheduled_time_of_arrival)
#summary(vuelosDeparted$scheduled_time_of_arrival)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que de momento no se modificara



### 4.15 actual_time_of_arrival  
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$actual_time_of_arrival)
#summary(vuelosDeparted$actual_time_of_arrival)

### Esta variable ya fue transformada a tipo Date pero contiene NAs, por lo que hay que determinar si es posible sustituir 
### los NAs por algun valor determinado en funcion de otras variables existentes

## 4.15.1
vuelosFechaNula <- vuelosDeparted[is.na(vuelosDeparted$actual_time_of_arrival)==TRUE,]
#str(vuelosFechaNula)  ## 3770 vuelos con fecha nula

## 4.15.2 Para aquellos casos en los que la fecha actual de llegada es nula, utilizaremos la suma de la fecha programada
## de llegada mas el retraso de llegada para obtener una fecha real de llegada del vuelo
vuelosDeparted2 <- vuelosDeparted
vuelosDeparted2$actual_time_of_arrival2 <- vuelosDeparted2$scheduled_time_of_arrival+minutes(vuelosDeparted2$arrival_delay)

## Comprobamos que la fechas calculadas (programada + retraso de salida) coinciden con las fechas actuales que ya tenemos
fechasIncorrectas <- vuelosDeparted2[vuelosDeparted2$actual_time_of_arrival!=vuelosDeparted2$actual_time_of_arrival2,]

fechasIncorrectas <- subset(fechasIncorrectas, 
                            select = c("scheduled_time_of_departure", "departure_delay", "actual_time_of_departure",
                                       "scheduled_time_of_arrival","arrival_delay","actual_time_of_arrival","actual_time_of_arrival2",
                                       "act_blocktime"))

#str(fechasIncorrectas)  ## 7669 fechas incorrectas con NAs en "actual_time_of_arrival"

## Eliminamos NAs
fechasIncorrectas <- fechasIncorrectas[is.na(fechasIncorrectas$actual_time_of_arrival)==FALSE,]
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
## No existen nulos pero existen valores negativos. (Estos valores negativos no tienen sentido)

negativos <- vuelosDeparted[vuelosDeparted$act_blocktime<0,]
#head(negativos)


## 4.19.1 almacenamos en una nueva variable la diferencia entre la fecha de llegada y la fecha de salida
vuelosDeparted2 <- vuelosDeparted
vuelosDeparted2$BlocktimeNEW <- as.integer(
                    difftime(vuelosDeparted2$actual_time_of_arrival, vuelosDeparted2$actual_time_of_departure, units = "mins"))

#head(vuelosDeparted2)

## Comprobamos si hay registros donde la nueva variable calculada (BlocktimeNEW) sea diferente a act_blocktime
#str(vuelosDeparted2)
tiemposDiferentes <- vuelosDeparted2[vuelosDeparted2$act_blocktime!=vuelosDeparted2$BlocktimeNEW,]

#str(tiemposDiferentes)
#head(tiemposDiferentes)


fechasRetrasos <- subset(tiemposDiferentes, 
                select = c("actual_time_of_departure","actual_time_of_arrival",
                           "act_blocktime","BlocktimeNEW","routing"))

#head(fechasRetrasos,5)

#table(fechasRetrasos$routing)

## Obtenemos diferentes rutas de ejemplo
## AMV-LEU      AMV +1            
## CNF-LEU      CNF -5

fechasRetrasos$difTiempoMin <- fechasRetrasos$BlocktimeNEW - fechasRetrasos$act_blocktime

### AMV-LEU
tiempoRuta <- fechasRetrasos[fechasRetrasos$routing=="AMV-LEU",]
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

## Este campo no contiene NAs y esta almacenado como tipo factor. No realizaremos cambios.





### 4.21 aircraft_registration_number
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$aircraft_registration_number)
#summary(vuelosDeparted$aircraft_registration_number)

## Este campo no contiene NAs y esta almacenado como tipo factor. No realizaremos cambios.




### 4.22 general_status_code
## (COMPLETADA)
###############################################################################################
## Este campo se analizo en un principio.





### 4.23 routing
## (COMPLETADA)
###############################################################################################

#str(vuelosDeparted$routing)
#summary(vuelosDeparted$routing, maxsum = 357)

## Este campo se almacena como factor y no contiene NAs.





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
cabin2Vacio <- vuelosDeparted[trimws(vuelosDeparted$cabin_2_code)=="",]
#head(cabin2Vacio)

## Comprobamos si algun registro con cabin_2_code vacio tiene valores almacenados en algun campo de cabin_2
cabin2ask <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_ask)==FALSE,]
cabin2saleable  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_saleable)==FALSE,]
cabin2fitted_configuration  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_fitted_configuration)==FALSE,]
cabin2pax_boarded  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_pax_boarded)==FALSE,]
cabin2rpk  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_rpk)==FALSE,]
cabin2ask  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_ask)==FALSE,]

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
cabin2Vacio <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_fitted_configuration)==TRUE,]
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
cabinNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_saleable)==TRUE,]

#str(cabinNA)
#summary(cabinNA)
#head(cabinNA)

## Se observa que hay 41 registros con cabin_2_code = J, que son lo que hacen la diferencia de esta variable
## con respecto a los NAs existentes en cabin_2_code

cabinJ <- cabinNA[cabinNA$cabin_2_code=="J",]

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
cabinPaxNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_1_pax_boarded)==TRUE,]

#str(cabinPaxNA)
#summary(cabinPaxNA)

## Las variables cabin_1_... y cabin_2_... son NAs. Eliminamos estos 3540 registros
vuelosDeparted <- vuelosDeparted[is.na(vuelosDeparted$cabin_1_pax_boarded)==FALSE,]

## cabin_2_pax_boarded

#str(vuelosDeparted$cabin_2_pax_boarded)
#summary(vuelosDeparted$cabin_2_pax_boarded)

## Campo almacenado como entero. Existen 89966 NAs 

## Obtenemos los NAs
cabinPaxNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_pax_boarded)==TRUE,]

#summary(cabinPaxNA)
## Haciendo el summary existen 198 registros con el campo "cabin_2_code" = J
cabinPaxNAJ <- cabinPaxNA[cabinPaxNA$cabin_2_code=="J",]

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

## Campo almacenado como entero.

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

## Campo almacenado como entero





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




### RESULTADO DEL DATAFRAME QUE UTILIZAREMOS PARA A?ADIR DATOS CLIMATICOS
#str(vuelosDeparted)   ## 212698 objetos
#str(vuelos)           ## original -> 222012 objetos




### 5. Creacion de nuevas variables en el dataframe
## 5.1. Mes de salida del vuelo
vuelosDeparted$mesSalida <- as.integer(month(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$mesSalida <- as.factor(vuelosDeparted$mesSalida)
## 5.1.1 ano de salida del vuelo
vuelosDeparted$anyoSalida <- as.integer(year(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$anyoSalida <- as.factor(vuelosDeparted$anyoSalida)
## 5.2. Dia de salida del vuelo
vuelosDeparted$diaSalida <- as.integer(day(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$diaSalida <- as.factor(vuelosDeparted$diaSalida)
## 5.3. Hora de salida del vuelo
vuelosDeparted$horaSalida <- format(vuelosDeparted$actual_time_of_departure,'%H:%M:%S')
vuelosDeparted$horaSalida <- as.factor(vuelosDeparted$horaSalida)


## 5.4 Mes de llegada del vuelo
vuelosDeparted$mesLlegada <- as.integer(month(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$mesLlegada <- as.factor(vuelosDeparted$mesLlegada)
## 5.1.1 ano de llegada del vuelo
vuelosDeparted$anyoLlegada <- as.integer(year(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$anyoLlegada <- as.factor(vuelosDeparted$anyoLlegada)
## 5.5 Dia de llegada del vuelo
vuelosDeparted$diaLlegada <- as.integer(day(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$diaLlegada <- as.factor(vuelosDeparted$diaLlegada)
## 5.6 Hora de llegada del vuelo
vuelosDeparted$horaLlegada <- format(vuelosDeparted$actual_time_of_arrival, "%H:%M:%S")
vuelosDeparted$horaLlegada <- as.factor(vuelosDeparted$horaLlegada)




## 5.7. Dia de la semana para la salida de los vuelos
vuelosDeparted$diaSemanaSalida <- weekdays(as.Date(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$diaSemanaSalida <- as.factor(vuelosDeparted$diaSemanaSalida)
## 5.8. Dia de la semana para la llegada de los vuelos
vuelosDeparted$diaSemanaLlegada <- weekdays(as.Date(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$diaSemanaLlegada <- as.factor(vuelosDeparted$diaSemanaLlegada)





## 6. Variables de tipo FACTOR
vuelosDeparted2 <- vuelosDeparted


## 6.1. Flight_Number
################################################

## 6.1.1. funcion que calcula el retraso medio de los codigos de vuelo indicados en la variable de entrada numVuelos e informa
## de la cantidad de vuelos que ha realizado un avion.
## Devuelve es un dataframe que almacena el codigo del avion, su retraso para cada vuelo realizado (puede repetirse) y 
## el numero de vuelos que ha realizado
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


### 6.1.2. Calcular el retraso medio de los aviones del dataframe
df <- subset(vuelosDeparted, select = c("arrival_delay","flight_number"))
numerosVuelo <- unique(df$flight_number)
mediaRetrasosVuelo <- mediasRetrasos(numerosVuelo,df)

## 6.1.3.  Comprobamos si existen numeros de vuelo que no tienen registros
str(numerosVuelo)   # 1045 numeros de vuelo
length(mediaRetrasosVuelo$retrasoMedio)    # 1022 numeros de vuelo
## Existen 23 numeros de vuelo sin registros de vuelo


### 6.1.4. Analisis de los retrasos medios
summary(mediaRetrasosVuelo$retrasoMedio)
barplot(mediaRetrasosVuelo$retrasoMedio)
boxplot(mediaRetrasosVuelo$retrasoMedio)  ## con boxplot podemos observar que los retrasos por encima del 20 y por 
## debajo del -18 son considerados atipicos


### 6.1.4.1. Retrasos Positivos
retrasoPos <- mediaRetrasosVuelo[mediaRetrasosVuelo$retrasoMedio>0,]
summary(retrasoPos$retrasoMedio)
length(retrasoPos$retrasoMedio)  # 521 aviones con retraso medio superior a 0
barplot(retrasoPos$retrasoMedio)
boxplot(retrasoPos$retrasoMedio)  ## Podemos deducir que los retrasos por encima de 20 minutos
## son considerados atipicos, asi como que la mayoria de los aviones tienen un retraso medio de entre 2 y 9 minutos

### 6.1.4.1.1. Retrasos entre 0 y 5 minutos (incluido)
retrasoEntre0y5min <- retrasoPos[retrasoPos$retrasoMedio>0 & retrasoPos$retrasoMedio<=5,]
summary(retrasoEntre0y5min)
length(retrasoEntre0y5min$retrasoMedio) ## 261 aviones

### 6.1.4.1.2. Retraso superior a 5 minutos e inferior o igual a 10
retrasoEntre5y10min <- retrasoPos[retrasoPos$retrasoMedio>5 & retrasoPos$retrasoMedio<=10,]
summary(retrasoEntre5y10min)
length(retrasoEntre5y10min$retrasoMedio) ## 142 aviones

### 6.1.4.1.3. Retraso mayor de 10 minutos
retrasoMayor10min <- retrasoPos[retrasoPos$retrasoMedio>10,]
summary(retrasoMayor10min)
length(retrasoMayor10min$retrasoMedio)  ## 118 aviones tienen un retraso medio superior a 10 min

##### Para los retrasos positivos podemos establecer 3 grupos.
# Grupo A: Aviones con un retraso medio superior a 0 minutos e inferior o igual a 5 minutos
# Grupo B: Aviones con un retraso medio superior a 5 minutos e inferior o igual a 10 minutos
# Gripo C: Aviones con un retraso medio superior a 10 minutos


### 6.1.4.2. Retrasos Negativos (llegadas antes de tiempo)
retrasoNeg <- mediaRetrasosVuelo[mediaRetrasosVuelo$retrasoMedio<=0,]
summary(retrasoNeg$retrasoMedio)
length(retrasoNeg$retrasoMedio)  # 501 aviones con retraso medio igual o inferior a 0
boxplot(retrasoNeg$retrasoMedio)  ## Podemos deducir que la mayoria de los aviones tiene un retraso comprendido entre
# -1 y -7 minutos

### 6.1.4.2.1. Retrasos comprendidos entre -1 y - 5(incluido)
retrasoNegEntre1y5 <- retrasoNeg[retrasoNeg$retrasoMedio<=(0) & retrasoNeg$retrasoMedio>=(-5),]
summary(retrasoNegEntre1y5)
length(retrasoNegEntre1y5$retrasoMedio) # 299 aviones

### 6.1.4.2.2. Retrasos comprendidos entre -6 y -7 (incluidos ambos)
retrasoNegEntre6y7 <- retrasoNeg[retrasoNeg$retrasoMedio<(-5),]
summary(retrasoNegEntre6y7)
length(retrasoNegEntre6y7$retrasoMedio) # 202 aviones

##### Para los retrasos negativos se pueden establecer 2 grupos
# Grupo D: Aviones con un retraso negativo entre 0 y -5 (incluido)
# Grupo E: Aviones con un retraso negativo superior a -5 (de -5 hasta -35)


### 6.1.2. Funcion que determina el grupo al que pertenece cada avion teniendo en cuenta su numero de vuelo y su retraso medio
asignarGrupoCodigoAvion <- function(dfRetrasos){
  vectorSalida <- vector()
  vectorRetrasos <- dfRetrasos[,2]
  for (i in 1:length(vectorRetrasos)){
    if(vectorRetrasos[i] > 0 & vectorRetrasos[i] <= 5){
      vectorSalida[i] = 1
    }
    if (vectorRetrasos[i] > 5 & vectorRetrasos[i] <= 10){
      vectorSalida[i] = 2
    }
    if (vectorRetrasos[i] > 10){
      vectorSalida[i] = 3
    }
    if (vectorRetrasos[i] <= 0 & vectorRetrasos[i] >=(-5)){
      vectorSalida[i] = 4
    }
    if (vectorRetrasos[i] <(-5)){
      vectorSalida[i] = 5
    }
  }
  return(as.factor(vectorSalida))
}

mediaRetrasosVuelo$fligthNumberGroup <- asignarGrupoCodigoAvion(mediaRetrasosVuelo)
## Comprobamos que se han indicado correctamente los grupos
head(mediaRetrasosVuelo)
summary(mediaRetrasosVuelo)
## En total, la suma de los aviones en cada grupo de la columna fligthNumberGroup da un resultado de 1022 aviones. OK

### 6.1.3. Añadir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
asignarGruposPorNumeroVuelo <- function(codigosVuelo, dfCodigosGrupos){
  ## codigosVuelo -> vector del dataframe total con los codigos de vuelo
  ## dfCodigosGrupos -> df con los codigos de vuelo y su retraso
  ## La funcion devuelve un vector indicando el grupo al que pertenece cada valor del vector CodigosVuelo
  
  vectorSalida <- vector()
  codigosVuelo <- as.character(codigosVuelo)
  vectorCodigos <- as.character(dfCodigosGrupos[,1])
  vectorGrupos <- dfCodigosGrupos[,2]
  
  for (i in 1:length(codigosVuelo)){
    for(j in 1:length(vectorCodigos)){
      if (codigosVuelo[i] == vectorCodigos[j]){
        vectorSalida[i] = vectorGrupos[j]
      }
    }
  }
  return(as.factor(vectorSalida))
}

dfCodigoGrupo <- mediaRetrasosVuelo
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

## 6.1.4 Añadir el nuevo vector al dataframe de vuelos
vuelosDeparted$flightNumberGroup <- asignarGruposPorNumeroVuelo(vuelosDeparted$flight_number,dfCodigoGrupo)
summary(vuelosDeparted$flightNumberGroup)
str(vuelosDeparted$flightNumberGroup)

## 6.1.5 Eliminar la variable analizada del dataframe resultante
vuelosDeparted2$flightNumberGroup <- vuelosDeparted$flightNumberGroup
vuelosDeparted2$flight_number <- NULL


####################################################################



## 6.2. Variable board_point
## 6.2.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","board_point"))
variables <- unique(df$board_point)
mediaPuntoEmbarque <- mediasRetrasos(variables,df)
boxplot(mediaPuntoEmbarque$retrasoMedio)
barplot(mediaPuntoEmbarque$retrasoMedio)
summary(mediaPuntoEmbarque$retrasoMedio)
str(mediaPuntoEmbarque)

## 6.2.2. Segmentamos la variable en funcion de los cuartiles obtenidos
## 6.2.2.1. retraso medio menoor o igual a -4,7
bpNegMenor4 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio<=(-4.77),]
str(bpNegMenor4)

## 6.2.2.2. retraso medio entre -4,7 y -1.69
bpNegEntre4y1 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio>(-4.77) & mediaPuntoEmbarque$retrasoMedio<=(-1.69),]
str(bpNegEntre4y1)

## 6.2.2.3. retraso medio entre -1.69 y 5.59
bpEntre1y5 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio>(-1.69) & mediaPuntoEmbarque$retrasoMedio<=5.59,]
str(bpEntre1y5)

## 6.2.2.4 retraso medio superior a 5.59
bpSup5 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio>5.59,]
str(bpSup5)

## Se determinan 4 grupos en base a los retrasos medios para la variable board_point, que son:
## retraso medio inferior o igual a -4.77       -> Grupo 1
## retraso medio entre -4.77 y -1.69 (incluido) -> Grupo 2
## retraso medio entre -1.69 y 5.59  (incluido) -> Grupo 3
## retraos medio superior a 5.59                -> Grupo 4


## Funcion para asignar grupos a la variable board_point
asignarGrupoBoardPoint <- function(dfRetrasos){
  vectorSalida <- vector()
  vectorRetrasos <- dfRetrasos[,2]
  for (i in 1:length(vectorRetrasos)){
    if(vectorRetrasos[i] <= (-4.47)){
      vectorSalida[i] = 1
    }
    if (vectorRetrasos[i] > (-4.47) & vectorRetrasos[i] <= (-1.69)){
      vectorSalida[i] = 2
    }
    if (vectorRetrasos[i] > (-1.69) & vectorRetrasos[i] <= 5.59){
      vectorSalida[i] = 3
    }
    if (vectorRetrasos[i] > 5.59 ){
      vectorSalida[i] = 4
    }
  }
  return(as.factor(vectorSalida))
}


mediaPuntoEmbarque$fligthNumberGroup <- asignarGrupoBoardPoint(mediaPuntoEmbarque)
## Comprobamos que se han indicado correctamente los grupos
head(mediaPuntoEmbarque)
summary(mediaPuntoEmbarque)
## En total, la suma de los aviones en cada grupo de la columna fligthNumberGroup da un resultado de 1022 aviones. OK

### 6.2.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
asignarGruposBoardPoint <- function(codigosVuelo, dfCodigosGrupos){
  ## codigosVuelo -> vector del dataframe total con los codigos de vuelo
  ## dfCodigosGrupos -> df con los codigos de vuelo y su retraso
  ## La funcion devuelve un vector indicando el grupo al que pertenece cada valor del vector CodigosVuelo
  
  vectorSalida <- vector()
  codigosVuelo <- as.character(codigosVuelo)
  vectorCodigos <- as.character(dfCodigosGrupos[,1])
  vectorGrupos <- dfCodigosGrupos[,2]
  
  for (i in 1:length(codigosVuelo)){
    for(j in 1:length(vectorCodigos)){
      if (codigosVuelo[i] == vectorCodigos[j]){
        vectorSalida[i] = vectorGrupos[j]
      }
    }
  }
  return(as.factor(vectorSalida))
}

dfCodigoGrupo <- mediaPuntoEmbarque
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

## 6.2.4 Añadir el nuevo vector al dataframe de vuelos
vuelosDeparted$boardPointGroup <- asignarGruposBoardPoint(vuelosDeparted$board_point ,dfCodigoGrupo)
summary(vuelosDeparted$boardPointGroup)
str(vuelosDeparted$boardPointGroup)

## 6.2.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$boardPointGroup <- vuelosDeparted$boardPointGroup
vuelosDeparted2$board_point <- NULL

str(vuelosDeparted2)
summary(vuelosDeparted2$boardPointGroup)

###################################################################### 

## 6.3 Board_lat (PENDIENTE)
## 6.3.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","board_lat"))
variables <- unique(df$board_lat)
mediaLatEmbarque <- mediasRetrasos(variables,df)
boxplot(mediaLatEmbarque$retrasoMedio)
barplot(mediaLatEmbarque$retrasoMedio)
summary(mediaLatEmbarque$retrasoMedio)
str(mediaLatEmbarque)

## 6.3.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.3.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.3.4 Añadir el nuevo vector al dataframe de vuelos
## 6.3.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada

###################################################################### 


## 6.4 Board_lon (PENDIENTE)
## 6.4.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","board_lon"))
variables <- unique(df$board_lon)
mediaBoardLon <- mediasRetrasos(variables,df)
boxplot(mediaBoardLon$retrasoMedio)
barplot(mediaBoardLon$retrasoMedio, names.arg=mediaBoardLon$codigo)
summary(mediaBoardLon$retrasoMedio)
str(mediaBoardLon)

## 6.4.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.4.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.4.4 Añadir el nuevo vector al dataframe de vuelos
## 6.4.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.5 Board_country_code (PENDIENTE)
## 6.5.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","board_country_code"))
variables <- unique(df$board_country_code)
mediaBoardCC <- mediasRetrasos(variables,df)
boxplot(mediaBoardCC$retrasoMedio)
barplot(mediaBoardCC$retrasoMedio, names.arg=mediaBoardCC$codigo)
summary(mediaBoardCC$retrasoMedio)
str(mediaBoardCC)

## 6.5.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.5.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.5.4 Añadir el nuevo vector al dataframe de vuelos
## 6.5.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.6 off_point (PENDIENTE)
## 6.6.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_point"))
variables <- unique(df$off_point)
mediaOffPoint <- mediasRetrasos(variables,df)
boxplot(mediaOffPoint$retrasoMedio)
barplot(mediaOffPoint$retrasoMedio, names.arg=mediaOffPoint$codigo)
summary(mediaOffPoint$retrasoMedio)
str(mediaOffPoint)

## 6.6.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.6.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.6.4 Añadir el nuevo vector al dataframe de vuelos
## 6.6.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.7 off_lat (PENDIENTE)
## 6.7.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_lat"))
variables <- unique(df$off_lat)
mediaOffLat <- mediasRetrasos(variables,df)
boxplot(mediaOffLat$retrasoMedio)
barplot(mediaOffLat$retrasoMedio, names.arg=mediaOffLat$codigo)
summary(mediaOffLat$retrasoMedio)
str(mediaOffLat)

## 6.7.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.7.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.7.4 Añadir el nuevo vector al dataframe de vuelos
## 6.7.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.8 off_lon (PENDIENTE)
## 6.8.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_lon"))
variables <- unique(df$off_lon)
mediaOffLon <- mediasRetrasos(variables,df)
boxplot(mediaOffLon$retrasoMedio)
barplot(mediaOffLon$retrasoMedio, names.arg=mediaOffLon$codigo)
summary(mediaOffLon$retrasoMedio)
str(mediaOffLon)

## 6.8.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.8.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.8.4 Añadir el nuevo vector al dataframe de vuelos
## 6.8.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.9 off_country_code (PENDIENTE)
## 6.9.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_country_code"))
variables <- unique(df$off_country_code)
mediaOffCC <- mediasRetrasos(variables,df)
boxplot(mediaOffCC$retrasoMedio)
barplot(mediaOffCC$retrasoMedio, names.arg=mediaOffCC$codigo)
summary(mediaOffCC$retrasoMedio)
str(mediaOffCC)

## 6.9.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.9.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.9.4 Añadir el nuevo vector al dataframe de vuelos
## 6.9.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.10 aircraft_type (PENDIENTE)
## 6.10.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","aircraft_type"))
variables <- unique(df$aircraft_type)
mediaTipoAvion <- mediasRetrasos(variables,df)
boxplot(mediaTipoAvion$retrasoMedio)
barplot(mediaTipoAvion$retrasoMedio, names.arg=mediaTipoAvion$codigo)
summary(mediaTipoAvion$retrasoMedio)
str(mediaTipoAvion)

## 6.10.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.10.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.10.4 Añadir el nuevo vector al dataframe de vuelos
## 6.10.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.11 aircraft_registration_number (PENDIENTE)
## 6.11.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","aircraft_registration_number"))
variables <- unique(df$aircraft_registration_number)
mediaNumRegAvion <- mediasRetrasos(variables,df)
boxplot(mediaNumRegAvion$retrasoMedio)
barplot(mediaNumRegAvion$retrasoMedio, names.arg=mediaNumRegAvion$codigo)
summary(mediaNumRegAvion$retrasoMedio)
str(mediaNumRegAvion)

## 6.11.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.11.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.11.4 Añadir el nuevo vector al dataframe de vuelos
## 6.11.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.12 routing (PENDIENTE)
## 6.12.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","routing"))
variables <- unique(df$routing)
mediaRutas <- mediasRetrasos(variables,df)
boxplot(mediaRutas$retrasoMedio)
barplot(mediaRutas$retrasoMedio, names.arg=mediaRutas$codigo)
summary(mediaRutas$retrasoMedio)
str(mediaRutas)

## 6.12.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.12.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.12.4 Añadir el nuevo vector al dataframe de vuelos
## 6.12.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.13 mesSalida (PENDIENTE)
## 6.13.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","mesSalida"))
variables <- unique(df$mesSalida)
mediaMesSalida <- mediasRetrasos(variables,df)
boxplot(mediaMesSalida$retrasoMedio)
barplot(mediaMesSalida$retrasoMedio, names.arg=mediaMesSalida$codigo)
summary(mediaMesSalida$retrasoMedio)
str(mediaMesSalida)

## 6.13.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.13.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.13.4 Añadir el nuevo vector al dataframe de vuelos
## 6.13.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.14 anyoSalida (PENDIENTE)


###################################################################### 


## 6.15 diaSalida (PENDIENTE)
## 6.15.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSalida"))
variables <- unique(df$diaSalida)
mediaDiaSalida <- mediasRetrasos(variables,df)
boxplot(mediaDiaSalida$retrasoMedio)
barplot(mediaDiaSalida$retrasoMedio, names.arg=mediaDiaSalida$codigo)
summary(mediaDiaSalida$retrasoMedio)
str(mediaDiaSalida)

## 6.15.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.15.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.15.4 Añadir el nuevo vector al dataframe de vuelos
## 6.15.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.16 horaSalida (PENDIENTE)
## 6.16.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","horaSalida"))
variables <- unique(df$horaSalida)
mediaHoraSalida <- mediasRetrasos(variables,df)
boxplot(mediaHoraSalida$retrasoMedio)
barplot(mediaHoraSalida$retrasoMedio, names.arg=mediaHoraSalida$codigo)
summary(mediaHoraSalida$retrasoMedio)
str(mediaHoraSalida)

## 6.16.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.16.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.16.4 Añadir el nuevo vector al dataframe de vuelos
## 6.16.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.17 mesLlegada (PENDIENTE)
## 6.17.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","mesLlegada"))
variables <- unique(df$mesLlegada)
mediaMesLlegada <- mediasRetrasos(variables,df)
boxplot(mediaMesLlegada$retrasoMedio)
barplot(mediaMesLlegada$retrasoMedio, names.arg=mediaMesLlegada$codigo)
summary(mediaMesLlegada$retrasoMedio)
str(mediaMesLlegada)

## 6.17.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.17.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.17.4 Añadir el nuevo vector al dataframe de vuelos
## 6.17.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.18 anyoLlegada (PENDIENTE)


###################################################################### 


## 6.19 diaLlegada (PENDIENTE)
## 6.19.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","diaLlegada"))
variables <- unique(df$diaLlegada)
mediaDiaLlegada <- mediasRetrasos(variables,df)
boxplot(mediaDiaLlegada$retrasoMedio)
barplot(mediaDiaLlegada$retrasoMedio, names.arg=mediaDiaLlegada$codigo)
summary(mediaDiaLlegada$retrasoMedio)
str(mediaDiaLlegada)

## 6.19.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.19.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.19.4 Añadir el nuevo vector al dataframe de vuelos
## 6.19.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.20 horaLlegada (PENDIENTE)
## 6.20.1. Calculamos el retraso medio. 
df <- subset(vuelosDeparted, select = c("arrival_delay","horaLlegada"))
variables <- unique(df$horaLlegada)
mediaHoraLlegada <- mediasRetrasos(variables,df)
boxplot(mediaHoraLlegada$retrasoMedio)
barplot(mediaHoraLlegada$retrasoMedio)
summary(mediaHoraLlegada$retrasoMedio)
str(mediaHoraLlegada)

## 6.20.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.20.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.20.4 Añadir el nuevo vector al dataframe de vuelos
## 6.20.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.21 diaSemanaSalida (PENDIENTE)
## 6.22.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSemanaSalida"))
variables <- unique(df$diaSemanaSalida)
mediaDiaSemSalida <- mediasRetrasos(variables,df)
boxplot(mediaDiaSemSalida$retrasoMedio)
barplot(mediaDiaSemSalida$retrasoMedio, names.arg=mediaDiaSemSalida$codigo)
summary(mediaDiaSemSalida$retrasoMedio)
str(mediaDiaSemSalida)

## 6.21.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.21.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.21.4 Añadir el nuevo vector al dataframe de vuelos
## 6.21.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.22 disSemanaLlegada (PENDIENTE)
## 6.22.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSemanaLlegada"))
variables <- unique(df$diaSemanaLlegada)
mediaDiaSemLlegada <- mediasRetrasos(variables,df)
boxplot(mediaDiaSemLlegada$retrasoMedio)
barplot(mediaDiaSemLlegada$retrasoMedio, names.arg=mediaDiaSemLlegada$codigo)
summary(mediaDiaSemLlegada$retrasoMedio)
str(mediaDiaSemLlegada)

## 6.22.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.22.3. Funcion para a�adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
## 6.22.4 Añadir el nuevo vector al dataframe de vuelos
## 6.22.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 






#####################################################################################################
########## ELIMINAR VARIABLES CATEGORICAS ANALIZADAS Y SIN ANALIZAR QUE NO TENGAN SENTIDO MANTENER


## Eliminamos la variable board_point del dataframe resultante
vuelosDeparted2$board_point <- NULL
## Eliminamos la variable general_status_code, ya que siempre sera Departed
vuelosDeparted2$general_status_code <- NULL
## Eliminamos las fechas, ya que tenemos las fechas divididas en dias, mes y hora
vuelosDeparted2$scheduled_time_of_arrival <- NULL
vuelosDeparted2$scheduled_time_of_departure <- NULL
vuelosDeparted2$actual_time_of_departure <- NULL
vuelosDeparted2$actual_time_of_arrival <- NULL

## Eliminamos la variable cabin_1_code, ya que solo tiene el valor 1
vuelosDeparted2$cabin_1_code <- NULL





































































## 7. Tabla de normalizacion de cada variable
obtenerTablaNormalizacion <- function(df){

  nombresdf <- colnames(df)
  nombres <- vector()
  maximos <- vector()
  minimos <- vector()
  
  for (i in 1:length(df)){
    nombres[i] <- nombresdf[i]
    if(is.numeric(df[,i])){
      vectorDatos <- df[,i]
      
      maximos[i] <- max(vectorDatos, na.rm = TRUE)
      minimos[i] <- min(vectorDatos, na.rm = TRUE)
    }
    else{
      maximos[i] <- 0
      minimos[i] <- 0
    }
    
  }
  maximos <- as.factor(maximos)
  minimos <- as.factor(minimos)
  
  dfaux <- as.data.frame(list(nombres,maximos,minimos), col.names = c("Columna","Maximo","Minimo"))
  return(dfaux)
  
}

vuelosDeparted2 <- head(vuelosDeparted, 1000)

tablaNormalizacion <- obtenerTablaNormalizacion(vuelosDeparted2)
tablaNormalizacion


## 8. Normalizar dataframe
## funcion que normaliza un dataframe (hay que mejorarle en los casos donde existen NAs)
normalizar <- function(df){
  
  ## df <- dataframe a normalizar
  for (i in 1:length(df)){
    columna <- vector()
    if(is.numeric(df[,i])){
      vectorDatos <- df[,i]
      maximo <- max(vectorDatos, na.rm = TRUE)
      minimo <- min(vectorDatos, na.rm = TRUE)
      for (j in 1:length(vectorDatos)){
        if(is.na(vectorDatos[j])){
          columna[j] = minimo
        }else{
          columna[j] = (vectorDatos[j]-minimo)/(maximo - minimo)
        }
      }
      df[,i] = columna
    }
  }
  
  return(df)
  
}

vuelosDeparted2 <- normalizar(vuelosDeparted)









str(vuelosDeparted2)
vuelosDeparted2$est_blocktime <- NULL
vuelosDeparted2$flight_number <- NULL
summary(vuelosDeparted2$general_status_code)
vuelosDeparted2$general_status_code <- NULL
vuelosDeparted2$scheduled_time_of_departure <- NULL
vuelosDeparted2$actual_time_of_departure <- NULL
vuelosDeparted2$scheduled_time_of_arrival <- NULL
vuelosDeparted2$actual_time_of_arrival <- NULL


#########################################     PUNTOS PENDIENTES   ###########################################


1. Se deben hacer grupos para el resto de variables de tipo factor en funcion de los retrasos medios
2. Almacenar la tabla de normalizacion (necesitamos los maximos y minimos de cada columna para realizar los test)
3. Mejorar la funcion de normalizacion (falla cuando hay NAs en el vector a normalizar)
4. Una vez tengamos todo hecho se deberan eliminar las variables que no aportan valor al modelo, como por ejemplo el año 
   del vuelo.

#############################################################################################################


## escribimos el dataframe resultante para reusarlo en la siguiente fase
write.csv('vuelosDeparted.csv',x = vuelosDeparted)
###


   
   
   
   
   
   
   
   
   
## board_point, board_lat, board_lon, board_country_code
   ###### board_point
str(vuelosDeparted)
uniqueBP <- unique(vuelosDeparted$board_point)
dfBP <- subset(vuelosDeparted, select = c("arrival_delay","board_point"))
dfBoardPoint <- mediasRetrasos(uniqueBP, dfBP)
barplot(dfBoardPoint$retrasoMedio)

    ##### board_lat
uniqueBL <- unique(vuelosDeparted$board_lat)
dfBL <- subset(vuelosDeparted, select = c("arrival_delay","board_lat"))
dfBoardLat <- mediasRetrasos(uniqueBL, dfBL)
barplot(dfBoardLat$retrasoMedio)

    ##### board_lon
uniqueBLn <- unique(vuelosDeparted$board_lon)
dfBLn <- subset(vuelosDeparted, select = c("arrival_delay","board_lon"))
dfBoardLon <- mediasRetrasos(uniqueBLn, dfBLn)
barplot(dfBoardLon$retrasoMedio)

    ##### board_country_code
uniqueBCC <- unique(vuelosDeparted$board_country_code)
dfBCC <- subset(vuelosDeparted, select = c("arrival_delay","board_country_code"))
dfBoardCC <- mediasRetrasos(uniqueBCC, dfBCC)
barplot(dfBoardCC$retrasoMedio)
#### Board_country_code aporta informacion diferente a las tres variables anteriores.
#### Board_point, board_lat y board_lon se pueden tratar como una unica variable, por lo tanto estudiaremos unicamente 
#### board_point
vuelosDeparted$board_lat <- NULL
vuelosDeparted$board_lon <- NULL


    ##### off_country_code
uniqueOCC <- unique(vuelosDeparted$off_country_code)
dfOCC <- subset(vuelosDeparted, select = c("arrival_delay","off_country_code"))
dfOffCC <- mediasRetrasos(uniqueOCC, dfOCC)
barplot(dfOffCC$retrasoMedio)

### board_country_code y off_country_code se trataran por separado

###### off_point
str(vuelosDeparted)
uniqueOP <- unique(vuelosDeparted$off_point)
dfOP <- subset(vuelosDeparted, select = c("arrival_delay","off_point"))
dfOffPoint <- mediasRetrasos(uniqueOP, dfOP)
barplot(dfOffPoint$retrasoMedio)

##### off_lat
uniqueOL <- unique(vuelosDeparted$off_lat)
dfOL <- subset(vuelosDeparted, select = c("arrival_delay","off_lat"))
dfOffLat <- mediasRetrasos(uniqueOL, dfOL)
barplot(dfOffLat$retrasoMedio)
str(dfOffLat)

##### off_lon
uniqueOLn <- unique(vuelosDeparted$off_lon)
dfOLn <- subset(vuelosDeparted, select = c("arrival_delay","off_lon"))
dfOffLon <- mediasRetrasos(uniqueOLn, dfOLn)
barplot(dfOffLon$retrasoMedio)
str(dfOffLon)

#### Al igual que anteriormente, off_point, off_lat y off_lon se trataran como una unica variable

#########  GRAFICAS DEL RETRASO EN FUNCION DE VARIABLES

library(ggplot2)

plot(vuelosDeparted$mesLlegada, vuelosDeparted$arrival_delay)
ggplot(vuelosDeparted$mesSalida, vuelosDeparted$arrival_delay)
beanplot(vuelosDeparted$diaLlegada, vuelosDeparted$arrival_delay)


str(vuelosDeparted)

## graficas de retraso de llegada en base a variables categoricas
ggplot(vuelosDeparted,aes(airline_code,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(flight_number,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(board_point,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(board_country_code,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(off_point,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(off_country_code,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(aircraft_type,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(aircraft_registration_number,arrival_delay)) + geom_violin(scale = "count")
#### ggplot(vuelosDeparted,aes(general_status_code,arrival_delay)) + geom_violin(scale = "count") no tiene sentido
#ggplot(vuelosDeparted,aes(routing,arrival_delay)) + geom_violin(scale = "count")
#### ggplot(vuelosDeparted,aes(cabin_1_code,arrival_delay)) + geom_violin(scale = "count") no tiene sentido
ggplot(vuelosDeparted,aes(cabin_2_code,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(mesSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(anyoSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaSalida,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(horaSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(mesLlegada,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(anyoLlegada,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaLlegada,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(horaLlegada,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaSemanaSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaSemanaLlegada,arrival_delay)) + geom_violin(scale = "count")


## graficas de retraso en base a variables numericas
ggplot(vuelosDeparted, aes(x = board_lat, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = board_lon, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = off_lat, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = off_lon, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = distance, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = departure_delay, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = act_blocktime, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_fitted_configuration, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_saleable, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_pax_boarded, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_rpk, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_ask, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = load_factor, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_pax, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_no_shows, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_cabin_crew, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_technical_crew, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_baggage_weight, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = number_of_baggage_pieces, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)


table(vuelosDeparted$horaLlegada)




#########  APLICACION DE MODELOS
# http://www.revistaseden.org/files/14-cap%2014.pdf

indices <- sample( 1:nrow( vuelosDeparted2 ), 150000 )
muestra <- vuelosDeparted2[ indices, ]

str(muestra)

head(vuelosDeparted2)

####################################################################


warnings()
length(d)
dfAux <- vuelosDeparted

model1 <- lm(arrival_delay ~ distance+act_blocktime+cabin_1_fitted_configuration+
               cabin_1_saleable+cabin_1_pax_boarded+cabin_1_rpk+cabin_1_ask+total_rpk+total_ask+load_factor+total_pax+
               total_no_shows+total_cabin_crew+total_technical_crew+total_baggage_weight+
               number_of_baggage_pieces+flightNumberCode, 
             na.action = na.omit, data = muestra)

summary(model1)


head(vuelosDeparted[vuelosDeparted$flight_number==7854,])
