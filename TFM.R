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

## Funcion que asigna el grupo al que pertenece cada dato incluido en la variable de entrada dfRetrasos dependiendo de
## los valores indicados en las variables cuartil1, mediana, cuartil2.
## Devuelve un vector con el grupo al que pertenece cada dato de entrada
asignarGrupoPorCuartiles <- function(dfRetrasos, cuartil1, mediana, cuartil2){
  vectorSalida <- vector()
  vectorRetrasos <- dfRetrasos[,2]
  for (i in 1:length(vectorRetrasos)){
    if(vectorRetrasos[i] <= cuartil1){
      vectorSalida[i] = 1
    }
    if (vectorRetrasos[i] > cuartil1 & vectorRetrasos[i] <= mediana){
      vectorSalida[i] = 2
    }
    if (vectorRetrasos[i] > mediana & vectorRetrasos[i] <= cuartil2){
      vectorSalida[i] = 3
    }
    if (vectorRetrasos[i] > cuartil2 ){
      vectorSalida[i] = 4
    }
  }
  return(as.factor(vectorSalida))
}


### Funcion que, dado el dataframe con todos los valores, asigna el grupo al que pertenece cada valor
asignarGruposDF <- function(codigos, dfCodigosGrupos){
  ## codigos -> vector del dataframe total con los codigos 
  ## dfCodigosGrupos -> df con los codigos y su retraso
  ## La funcion devuelve un vector indicando el grupo al que pertenece cada valor del vector CodigosVuelo
  
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
  return(as.factor(vectorSalida))
}
##################################################################################################


## 6.1. Flight_Number
## 6.1.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","flight_number"))
variables <- unique(df$flight_number)
mediaRetrasosVuelo <- mediasRetrasos(variables,df)
boxplot(mediaRetrasosVuelo$retrasoMedio)
barplot(mediaRetrasosVuelo$retrasoMedio)
summary(mediaRetrasosVuelo$retrasoMedio)
str(mediaRetrasosVuelo)

## 6.1.2. Segmentamos la variable en funcion de los cuartiles obtenidos
## 6.1.2.1 retraso medio menor o igual a -3.794
FNmenor3 <- mediaRetrasosVuelo[mediaRetrasosVuelo$retrasoMedio<=(-3.794),]
str(FNmenor3)

## 6.1.2.2 retraso medio entre -3.794 y 0.2435 (incluido)
FNentre3y0 <- mediaRetrasosVuelo[mediaRetrasosVuelo$retrasoMedio>(-3.794) & mediaRetrasosVuelo$retrasoMedio <= 0.2435,]
str(FNentre3y0)

## 6.1.2.3 retraso medio entre 0.2435 y 5.133 (incluido)
FNentre0y5 <- mediaRetrasosVuelo[mediaRetrasosVuelo$retrasoMedio>0.2435 & mediaRetrasosVuelo$retrasoMedio <= 5.133,]
str(FNentre0y5)

## 6.1.2.4 retraso medio superior a 5.133
FNsup5 <- mediaRetrasosVuelo[mediaRetrasosVuelo$retrasoMedio>5.133,]
str(FNsup5)

## Los grupos formados en base al retraso medio son los siguientes:
## retraso inferior o igual a -3.794          -> 1
## retraso entre -3.794 y 0.2435 (incluido)   -> 2
## retraso entre 0.2435 y 5.133 (incluido)    -> 3
## retraso superior a 5.133                   -> 4


## 6.1.3. A?adir al dataframe de vuelos una columna con los grupos a los que pertenece cada avion
cuartil1 <- quantile(mediaRetrasosVuelo$retrasoMedio,.25)
mediana <- quantile(mediaRetrasosVuelo$retrasoMedio,.50)
cuartil2 <- quantile(mediaRetrasosVuelo$retrasoMedio,.75)

mediaRetrasosVuelo$fligthNumberGroup <- asignarGrupoPorCuartiles(mediaRetrasosVuelo, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaRetrasosVuelo)
summary(mediaRetrasosVuelo)
table(mediaRetrasosVuelo$fligthNumberGroup)


## 6.1.4 Añadir el nuevo vector al dataframe de vuelos
dfCodigoGrupo <- mediaRetrasosVuelo
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$flightNumberGroup <- asignarGruposDF(vuelosDeparted$flight_number,dfCodigoGrupo)
summary(vuelosDeparted$flightNumberGroup)
str(vuelosDeparted$flightNumberGroup)


## 6.1.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$flightNumberGroup <- vuelosDeparted$flightNumberGroup
vuelosDeparted2$flight_number <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$fligthNumberGroup==3,]
vuelosDeparted2[vuelosDeparted2$flight_number == 232,]
table(vuelosDeparted2$flightNumberGroup)


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
## 6.2.2.1. retraso medio menoor o igual a -4,775
bpNegMenor4 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio<=(-4.775),]
str(bpNegMenor4)

## 6.2.2.2. retraso medio entre -4,775 y -1.695
bpNegEntre4y1 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio>(-4.775) & mediaPuntoEmbarque$retrasoMedio<=(-1.695),]
str(bpNegEntre4y1)

## 6.2.2.3. retraso medio entre -1.695 y 5.593
bpEntre1y5 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio>(-1.695) & mediaPuntoEmbarque$retrasoMedio<=5.593,]
str(bpEntre1y5)

## 6.2.2.4 retraso medio superior a 5.593
bpSup5 <- mediaPuntoEmbarque[mediaPuntoEmbarque$retrasoMedio>5.593,]
str(bpSup5)

## Se determinan 4 grupos en base a los retrasos medios para la variable board_point, que son:
## retraso medio inferior o igual a -4.775        -> Grupo 1
## retraso medio entre -4.775 y -1.695 (incluido) -> Grupo 2
## retraso medio entre -1.695 y 5.593  (incluido) -> Grupo 3
## retraos medio superior a 5.593                 -> Grupo 4


### 6.2.3. A?adir al dataframe una columna con los grupos a los que pertenece cada avion
cuartil1 <- quantile(mediaPuntoEmbarque$retrasoMedio,.25)
mediana <- quantile(mediaPuntoEmbarque$retrasoMedio,.50)
cuartil2 <- quantile(mediaPuntoEmbarque$retrasoMedio,.75)


mediaPuntoEmbarque$boardPointGroup <- asignarGrupoPorCuartiles(mediaPuntoEmbarque, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaPuntoEmbarque)
summary(mediaPuntoEmbarque)
str(mediaPuntoEmbarque)
table(mediaPuntoEmbarque$boardPointGroup)


## 6.2.4 Añadir el nuevo vector al dataframe de vuelos
dfCodigoGrupo <- mediaPuntoEmbarque
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$boardPointGroup <- asignarGruposDF(vuelosDeparted$board_point ,dfCodigoGrupo)
summary(vuelosDeparted$boardPointGroup)
str(vuelosDeparted$boardPointGroup)

## 6.2.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$boardPointGroup <- vuelosDeparted$boardPointGroup
vuelosDeparted2$board_point <- NULL

str(vuelosDeparted2)
summary(vuelosDeparted2$boardPointGroup)

head(vuelosDeparted)

###################################################################### 



## 6.3 Board_lat (COMPLETADA)
## 6.3.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","board_lat"))
variables <- unique(df$board_lat)
mediaLatEmbarque <- mediasRetrasos(variables,df)
boxplot(mediaLatEmbarque$retrasoMedio)
barplot(mediaLatEmbarque$retrasoMedio)
summary(mediaLatEmbarque$retrasoMedio)
str(mediaLatEmbarque)

## 6.3.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.3.2.1 Retraso menor o igual a -4.775
blNegMenor4 <- mediaLatEmbarque[mediaLatEmbarque$retrasoMedio<=(-4.775),]
summary(blNegMenor4)
str(blNegMenor4)

## 6.3.2.2 Retraso entre -4.775 y -1.695 (incluido)
blNegEntre4y1 <- mediaLatEmbarque[mediaLatEmbarque$retrasoMedio>(-4.775) & mediaLatEmbarque$retrasoMedio<=(-1.695),]
summary(blNegEntre4y1)
str(blNegEntre4y1)

## 6.3.2.3 Retraso entre -1.695 y 5.593 (incluido)
blEntre1y5 <- mediaLatEmbarque[mediaLatEmbarque$retrasoMedio>(-1.695) & mediaLatEmbarque$retrasoMedio<=5.593,]
summary(blEntre1y5)
str(blEntre1y5)

## 6.3.2.4 Retraso superior a 5.593
blsuperior5 <- mediaLatEmbarque[mediaLatEmbarque$retrasoMedio>5.593,]
summary(blsuperior5)
str(blsuperior5)

## En base a esta segmentacion se determinan los siguientes grupos:
## Retraso medio inferior o igual a -4.775         -> 1 
## Retraso medio entre -4.775 y -1.695 (incluido)  -> 2
## Retraso medio entre -1.695 y 5.593 (incluido)   -> 3
## Retraso medio superior a 5.593                  -> 4


## 6.3.3. Funcion para a?adir al dataframe una columna con los grupos obtenidos en base a la latitud de embarque
cuartil1 <- quantile(mediaLatEmbarque$retrasoMedio,.25)
mediana <- quantile(mediaLatEmbarque$retrasoMedio,.50)
cuartil2 <- quantile(mediaLatEmbarque$retrasoMedio,.75)


mediaLatEmbarque$boardLatGroup <- asignarGrupoPorCuartiles(mediaLatEmbarque, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaLatEmbarque)
summary(mediaLatEmbarque)

## 6.3.4 Añadir el nuevo vector al dataframe de vuelos
dfCodigoGrupo <- mediaLatEmbarque
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$boardLatGroup <- asignarGruposDF(vuelosDeparted$board_lat ,dfCodigoGrupo)
summary(vuelosDeparted$boardLatGroup)
str(vuelosDeparted$boardLatGroup)

## 6.3.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$boardLatGroup <- vuelosDeparted$boardLatGroup
vuelosDeparted2$board_lat <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$boardLatGroup==2,]
vuelosDeparted2[vuelosDeparted2$board_lat == 64.9,]

str(vuelosDeparted2)
summary(vuelosDeparted2$boardLatGroup)


###################################################################### 



## 6.4 Board_lon (COMPLETADA)
## 6.4.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","board_lon"))
variables <- unique(df$board_lon)
mediaBoardLon <- mediasRetrasos(variables,df)
boxplot(mediaBoardLon$retrasoMedio)
barplot(mediaBoardLon$retrasoMedio, names.arg=mediaBoardLon$codigo)
summary(mediaBoardLon$retrasoMedio)
str(mediaBoardLon)

## 6.4.2 Segmentamos la variable en grupos en base a su retraso medio
## 6.4.2.1 retraso medio inferior o igual a -4.775
BLinferior4 <- mediaBoardLon[mediaBoardLon$retrasoMedio<=(-4.775),]
str(BLinferior4)

## 6.4.2.2 retraso medio entre -4.775 y -1.695 (incluido)
BLentre4y1 <- mediaBoardLon[mediaBoardLon$retrasoMedio>(-4.775) & mediaBoardLon$retrasoMedio<=(-1.695),]
str(BLentre4y1)

## 6.4.2.3 retraso medio entre -1.695 y 5.593 (incluido)
BLentre1y5 <- mediaBoardLon[mediaBoardLon$retrasoMedio>(-1.695) & mediaBoardLon$retrasoMedio<=5.593,]
str(BLentre1y5)

## 6.4.2.4 retraso medio superior a 5.593
BLSup5 <- mediaBoardLon[mediaBoardLon$retrasoMedio>5.593,]
str(BLSup5)

## En base a los cuartiles se obtienen 4 grupos
## retraso medio inferior o igual a -4.775        -> 1
## retraso medio entre -4.775 y -1.695 (incluido) -> 2
## retraso medio entre -1.695 y 5.593 (incluido)  -> 3
## retraso medio superior a 5.593                 -> 4

## 6.4.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base a la longitud de embarque
cuartil1 <- quantile(mediaBoardLon$retrasoMedio,.25)
mediana <- quantile(mediaBoardLon$retrasoMedio,.50)
cuartil2 <- quantile(mediaBoardLon$retrasoMedio,.75)

mediaBoardLon$boardLonGroup <- asignarGrupoPorCuartiles(mediaBoardLon, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaBoardLon)
summary(mediaBoardLon)

## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaBoardLon
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL


## 6.4.4 Añadir el nuevo vector al dataframe de vuelos
vuelosDeparted$boardLonGroup <- asignarGruposDF(vuelosDeparted$board_lon ,dfCodigoGrupo)
summary(vuelosDeparted$boardLonGroup)
str(vuelosDeparted$boardLonGroup)


## 6.4.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$boardLonGroup <- vuelosDeparted$boardLonGroup
vuelosDeparted2$board_lon <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$boardLonGroup==1,]
vuelosDeparted2[vuelosDeparted2$board_lon == (-95.34212),]

str(vuelosDeparted2)
summary(vuelosDeparted2$boardLonGroup)



###################################################################### 


## 6.5 Board_country_code (COMPLETADA)
## 6.5.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","board_country_code"))
variables <- unique(df$board_country_code)
mediaBoardCC <- mediasRetrasos(variables,df)
boxplot(mediaBoardCC$retrasoMedio)
barplot(mediaBoardCC$retrasoMedio, names.arg=mediaBoardCC$codigo)
summary(mediaBoardCC$retrasoMedio)
str(mediaBoardCC)

## 6.5.2 Segmentamos la variable en grupos en base a su retraso medio
## 6.5.2.1 retraso medio inferior o igual a -4.38
BCCmenor4 <- mediaBoardCC[mediaBoardCC$retrasoMedio<=(-4.38),]
str(BCCmenor4)

## 6.5.2.2 retraso medio entre -4.38 y -1.74 (incluido)
BCCentre4y1 <- mediaBoardCC[mediaBoardCC$retrasoMedio>(-4.38) &mediaBoardCC$retrasoMedio<=(-1.74),]
str(BCCentre4y1)

## 6.5.2.3 retraso medio entre -1.74 y 4.036 (incluido)
BCCentre1y4 <- mediaBoardCC[mediaBoardCC$retrasoMedio>(-1.74) &mediaBoardCC$retrasoMedio<=4.036,]
str(BCCentre1y4)

## 6.5.2.4 retraso medio superior a 4.036
BCCsup4 <- mediaBoardCC[mediaBoardCC$retrasoMedio>4.036,]
str(BCCsup4)

## En base a los cuartiles obtenemos 4 grupos
## retraso inferior o igual a -4.38         -> 1 
## retraso entre -4.38 y -1.74 (incluido)   -> 2
## retraso entre -1.74 y 4.036 (incluido)   -> 3
## retraso superior a 4.036                 -> 4


## 6.5.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al codigo del pais de embarque
cuartil1 <- quantile(mediaBoardCC$retrasoMedio,.25)
mediana <- quantile(mediaBoardCC$retrasoMedio,.50)
cuartil2 <- quantile(mediaBoardCC$retrasoMedio,.75)

mediaBoardCC$boardCountryCodeGroup <- asignarGrupoPorCuartiles(mediaBoardCC, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaBoardCC)
summary(mediaBoardCC)

## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaBoardCC
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

## 6.5.4 Añadir el nuevo vector al dataframe de vuelos
vuelosDeparted$boardCountryCodeGroup <- asignarGruposDF(vuelosDeparted$board_country_code ,dfCodigoGrupo)
summary(vuelosDeparted$boardCountryCodeGroup)
str(vuelosDeparted$boardCountryCodeGroup)

## 6.5.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$boardCountryCodeGroup <- vuelosDeparted$boardCountryCodeGroup
vuelosDeparted2$board_country_code <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$boardCountryCodeGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$board_country_code == "MC",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$boardCountryCodeGroup)

###################################################################### 


## 6.6 off_point (COMPLETADA)
## 6.6.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_point"))
variables <- unique(df$off_point)
mediaOffPoint <- mediasRetrasos(variables,df)
boxplot(mediaOffPoint$retrasoMedio)
barplot(mediaOffPoint$retrasoMedio, names.arg=mediaOffPoint$codigo)
summary(mediaOffPoint$retrasoMedio)
str(mediaOffPoint)

## 6.6.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.6.2.1 retraso medio menor o igual a -2.794
OPmenor2 <- mediaOffPoint[mediaOffPoint$retrasoMedio <=(-2.794),]
str(OPmenor2)

## 6.6.2.2 retraso medio entre -2.794 y 1.180 (incluido)
OPentre2y1 <- mediaOffPoint[mediaOffPoint$retrasoMedio >(-2.794) & mediaOffPoint$retrasoMedio <= 1.180,]
str(OPentre2y1)

## 6.6.2.3 retraso medio entre 1.180 y 4.769 (incluido)
OPentre1y4 <- mediaOffPoint[mediaOffPoint$retrasoMedio > 1.180 & mediaOffPoint$retrasoMedio <= 4.769,]
str(OPentre1y4)

## 6.6.2.4 retraso medio superior a 4.796
OPsup4 <- mediaOffPoint[mediaOffPoint$retrasoMedio > 4.796,]
str(OPsup4)

## En base al retraso medio, los cuatro grupos quedan de la siguiente forma:
## retraso medio inferior o igual a -2.794          -> 1
## retraso medio entre -2.794 y 1.180 (incluido)    -> 2
## retraso medio entre 1.180 y 4.796 (incluido)     -> 3
## retraso medio superior a 4.796                   -> 4


## 6.6.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al punto de llegada
cuartil1 <- quantile(mediaOffPoint$retrasoMedio,.25)
mediana <- quantile(mediaOffPoint$retrasoMedio,.50)
cuartil2 <- quantile(mediaOffPoint$retrasoMedio,.75)

mediaOffPoint$offPointGroup <- asignarGrupoPorCuartiles(mediaOffPoint, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaOffPoint)
summary(mediaOffPoint)


## 6.6.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaOffPoint
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$offPointGroup <- asignarGruposDF(vuelosDeparted$off_point ,dfCodigoGrupo)
summary(vuelosDeparted$offPointGroup)
str(vuelosDeparted$offPointGroup)


## 6.6.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$offPointGroup <- vuelosDeparted$offPointGroup
vuelosDeparted2$off_point <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$offPointGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$off_point == "GRW",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$offPointGroup)


###################################################################### 


## 6.7 off_lat (COMPLETADA)
## 6.7.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_lat"))
variables <- unique(df$off_lat)
mediaOffLat <- mediasRetrasos(variables,df)
boxplot(mediaOffLat$retrasoMedio)
barplot(mediaOffLat$retrasoMedio, names.arg=mediaOffLat$codigo)
summary(mediaOffLat$retrasoMedio)
str(mediaOffLat)

## 6.7.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.7.2.1 retraso medio inferior o igual a -2.794
OLmenor2 <- mediaOffLat[mediaOffLat$retrasoMedio <= (-2.794),]
str(OLmenor2)

## 6.7.2.2 retraso medio entre -2.794 y 1.180 (incluido)
OLentre2y1 <- mediaOffLat[mediaOffLat$retrasoMedio > (-2.794) & mediaOffLat$retrasoMedio <= 1.18,]
str(OLentre2y1)

## 6.7.2.3 retraso medio entre 1.180 y 4.796 (incluido)
OLentre1y4 <- mediaOffLat[mediaOffLat$retrasoMedio > 1.18 & mediaOffLat$retrasoMedio <= 4.796,]
str(OLentre1y4)

## 6.7.2.4 retraso medio superior a 4.796
OLsuperior4 <- mediaOffLat[mediaOffLat$retrasoMedio > 4.796,]
str(OLsuperior4)

## Los grupos en funcion de los cuartiles quedarian de la siguiente forma:
## retraso medio inferior o igual a -2.794        -> 1
## retraso medio entre -2.794 y 1.18 (incluido)   -> 2
## retraso medio entre 1.18 y 4.796 (incluido)    -> 3
## retraso medio superior a 4.796                 -> 4


## 6.7.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base a la latitud de llegada
cuartil1 <- quantile(mediaOffLat$retrasoMedio,.25)
mediana <- quantile(mediaOffLat$retrasoMedio,.50)
cuartil2 <- quantile(mediaOffLat$retrasoMedio,.75)

mediaOffLat$offLatGroup <- asignarGrupoPorCuartiles(mediaOffLat, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaOffLat)
summary(mediaOffLat)


## 6.7.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaOffLat
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$offLatGroup <- asignarGruposDF(vuelosDeparted$off_lat ,dfCodigoGrupo)
summary(vuelosDeparted$offLatGroup)
str(vuelosDeparted$offLatGroup)


## 6.7.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$offLatGroup <- vuelosDeparted$offLatGroup
vuelosDeparted2$off_lat <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$offLatGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$off_lat == 39.98567,],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$offLatGroup)



###################################################################### 


## 6.8 off_lon (COMPLETADA)
## 6.8.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_lon"))
variables <- unique(df$off_lon)
mediaOffLon <- mediasRetrasos(variables,df)
boxplot(mediaOffLon$retrasoMedio)
barplot(mediaOffLon$retrasoMedio, names.arg=mediaOffLon$codigo)
summary(mediaOffLon$retrasoMedio)
str(mediaOffLon)

## 6.8.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.8.2.1 retraso medio inferior o igual a -2.799
OLinf2 <- mediaOffLon[mediaOffLon$retrasoMedio <= (-2.799),]
str(OLinf2)

## 6.8.2.2 retraso medio entre -2.799 y 1.175 (incluido)
OLentre2y1 <- mediaOffLon[mediaOffLon$retrasoMedio > (-2.799) & mediaOffLon$retrasoMedio <= 1.175,]
str(OLentre2y1)

## 6.8.2.3 retraso medio entre 1.175 y 4.635 (incluido)
OLentre1y4 <- mediaOffLon[mediaOffLon$retrasoMedio > 1.175 & mediaOffLon$retrasoMedio <= 4.635,]
str(OLentre1y4)

## 6.8.2.4 retraso medio superior a 4.635
OLsup4 <- mediaOffLon[mediaOffLon$retrasoMedio > 4.635,]
str(OLsup4)

## Los grupos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a -2.799        -> 1
## retraso medio entre -2.799 y 1.175 (incluido)  -> 2
## retraso medio entre 1.175 y 4.635 (incluido)   -> 3
## retraso medio superior a 4.635                 -> 4


## 6.8.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base a la longitud de llegada
cuartil1 <- quantile(mediaOffLon$retrasoMedio,.25)
mediana <- quantile(mediaOffLon$retrasoMedio,.50)
cuartil2 <- quantile(mediaOffLon$retrasoMedio,.75)

mediaOffLon$offLonGroup <- asignarGrupoPorCuartiles(mediaOffLon, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaOffLon)
summary(mediaOffLon)


## 6.8.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaOffLon
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$offLonGroup <- asignarGruposDF(vuelosDeparted$off_lon ,dfCodigoGrupo)
summary(vuelosDeparted$offLonGroup)
str(vuelosDeparted$offLonGroup)


## 6.8.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$offLonGroup <- vuelosDeparted$offLonGroup
vuelosDeparted2$off_lon <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$offLonGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$off_lon == 31.81222,],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$offLonGroup)



###################################################################### 


## 6.9 off_country_code (COMPLETADA)
## 6.9.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","off_country_code"))
variables <- unique(df$off_country_code)
mediaOffCC <- mediasRetrasos(variables,df)
boxplot(mediaOffCC$retrasoMedio)
barplot(mediaOffCC$retrasoMedio, names.arg=mediaOffCC$codigo)
summary(mediaOffCC$retrasoMedio)
str(mediaOffCC)

## 6.9.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.9.2.1 retraso medio inferior o igual a -1.636
OCCinf1 <- mediaOffCC[mediaOffCC$retrasoMedio <= (-1.636),]
str(OCCinf1)

## 6.9.2.2 retraso medio entre -1.636 y 0.6818 (incluido)
OCCentre1y0 <- mediaOffCC[mediaOffCC$retrasoMedio > (-1.636) & mediaOffCC$retrasoMedio <= 0.6818,]
str(OCCentre1y0)

## 6.9.2.3 retraso medio entre 0.6818 y 3 (incluido)
OCCentre0y3 <- mediaOffCC[mediaOffCC$retrasoMedio > 0.6818 & mediaOffCC$retrasoMedio <= 3,]
str(OCCentre0y3)

## 6.9.2.4 retraso medio superior a 3
OCCsup3 <- mediaOffCC[mediaOffCC$retrasoMedio > 3,]
str(OCCsup3)

## los grupos en funcion de los cuartiles quedarian de la siguiente forma:
## retraso medio inferior a -1.636              -> 1
## retraso medio entre -1.636 y 0.6818          -> 2
## retraso medio entre 0.6818 y 3 (incluido)    -> 3
## retraso medio superior a 3                   -> 4


## 6.9.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al codigo de pais de llegada
cuartil1 <- quantile(mediaOffCC$retrasoMedio,.25)
mediana <- quantile(mediaOffCC$retrasoMedio,.50)
cuartil2 <- quantile(mediaOffCC$retrasoMedio,.75)

mediaOffCC$offCountryCodeGroup <- asignarGrupoPorCuartiles(mediaOffCC, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaOffCC)
summary(mediaOffCC)


## 6.9.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaOffCC
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$offCountryCodeGroup <- asignarGruposDF(vuelosDeparted$off_country_code ,dfCodigoGrupo)
summary(vuelosDeparted$offCountryCodeGroup)
str(vuelosDeparted$offCountryCodeGroup)


## 6.9.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$offCountryCodeGroup <- vuelosDeparted$offCountryCodeGroup
vuelosDeparted2$off_country_code <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$offCountryCodeGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$off_country_code == "DK",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$offCountryCodeGroup)



###################################################################### 


## 6.10 aircraft_type (COMPLETADA)
## 6.10.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","aircraft_type"))
variables <- unique(df$aircraft_type)
mediaTipoAvion <- mediasRetrasos(variables,df)
boxplot(mediaTipoAvion$retrasoMedio)
barplot(mediaTipoAvion$retrasoMedio, names.arg=mediaTipoAvion$codigo)
summary(mediaTipoAvion$retrasoMedio)
str(mediaTipoAvion)

## 6.10.2. Segmentamos la variable en grupos en base a su retraso medio
## 6.10.2.1 retraso medio inferior o igual a -1.106
ATinf1 <- mediaTipoAvion[mediaTipoAvion$retrasoMedio <= (-1.106),]
str(ATinf1)

## 6.10.2.2 retraso medio entre -1.106 y 1.103 (incluido)
ATentre1y1 <- mediaTipoAvion[mediaTipoAvion$retrasoMedio > (-1.106) & mediaTipoAvion$retrasoMedio <= 1.103,]
str(ATentre1y1)

## 6.10.2.3 retraso medio entre 1.103 y 3.331 (incluido)
ATentre1y3 <- mediaTipoAvion[mediaTipoAvion$retrasoMedio > 1.103 & mediaTipoAvion$retrasoMedio <= 3.331,]
str(ATentre1y3)

## 6.10.2.4 retraso medio superior a 3.331
ATsup3 <- mediaTipoAvion[mediaTipoAvion$retrasoMedio > 3.331,]
str(ATsup3)

## los retrasos medios en funcion a los cuartiles quedarian de la siguente forma:
## retraso medio inferior o igual a -1.106          -> 1
## retraso medio entre -1.106 y 1.103 (incluido)    -> 2
## retraso medio entre 1.103 y 3.331 (incluido)     -> 3
## retraso medio superior a 3.331                   -> 4


## 6.10.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al tipo de avion
cuartil1 <- quantile(mediaTipoAvion$retrasoMedio,.25)
mediana <- quantile(mediaTipoAvion$retrasoMedio,.50)
cuartil2 <- quantile(mediaTipoAvion$retrasoMedio,.75)

mediaTipoAvion$aircraftTypeGroup <- asignarGrupoPorCuartiles(mediaTipoAvion, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaTipoAvion)
summary(mediaTipoAvion)


## 6.10.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaTipoAvion
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$aircraftTypeGroup <- asignarGruposDF(vuelosDeparted$aircraft_type ,dfCodigoGrupo)
summary(vuelosDeparted$aircraftTypeGroup)
str(vuelosDeparted$aircraftTypeGroup)



## 6.10.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$aircraftTypeGroup <- vuelosDeparted$aircraftTypeGroup
vuelosDeparted2$aircraft_type <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$aircraftTypeGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$aircraft_type == "AT7",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$aircraftTypeGroup)



###################################################################### 


## 6.11 aircraft_registration_number (COMPLETADA)
## 6.11.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","aircraft_registration_number"))
variables <- unique(df$aircraft_registration_number)
mediaNumRegAvion <- mediasRetrasos(variables,df)
boxplot(mediaNumRegAvion$retrasoMedio)
barplot(mediaNumRegAvion$retrasoMedio, names.arg=mediaNumRegAvion$codigo)
summary(mediaNumRegAvion$retrasoMedio)
str(mediaNumRegAvion)

## 6.11.2. Segmentamos la variable en grupos en base a su retraso medio
## retraso medio inferior o igual a -1.7670
ARNinf1 <- mediaNumRegAvion[mediaNumRegAvion$retrasoMedio <= (-1.7670),]
str(ARNinf1)

## retraso medio entre -1.7670 y -0.7803 (incluido)
ARNentre1y0 <- mediaNumRegAvion[mediaNumRegAvion$retrasoMedio > (-1.7670) & mediaNumRegAvion$retrasoMedio <= (-0.7803),]
str(ARNentre1y0)

## retraso medio entre -0.7803 y 2.2510 (incluido)
ARNentre0y2 <- mediaNumRegAvion[mediaNumRegAvion$retrasoMedio > (-0.7803) & mediaNumRegAvion$retrasoMedio <= 2.2510,]
str(ARNentre0y2)

## retraso medio superior a 2.2510
ARNsup2 <- mediaNumRegAvion[mediaNumRegAvion$retrasoMedio > 2.2510,]
str(ARNsup2)


## los grupos de los retrasos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a -1.7670           -> 1
## retraso medio entre -1.7670 y -0.7803 (incluido)   -> 2
## retraso medio entre -0.7803 y 2.2510 (incluido)    -> 3
## retraso medio superior a 2.2510                    -> 4


## 6.11.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al numero de registro del avion
cuartil1 <- quantile(mediaNumRegAvion$retrasoMedio,.25)
mediana <- quantile(mediaNumRegAvion$retrasoMedio,.50)
cuartil2 <- quantile(mediaNumRegAvion$retrasoMedio,.75)

mediaNumRegAvion$aircraftRegNumberGroup <- asignarGrupoPorCuartiles(mediaNumRegAvion, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaNumRegAvion)
summary(mediaNumRegAvion)


## 6.11.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaNumRegAvion
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$aircraftRegNumberGroup <- asignarGruposDF(vuelosDeparted$aircraft_registration_number ,dfCodigoGrupo)
summary(vuelosDeparted$aircraftRegNumberGroup)
str(vuelosDeparted$aircraftRegNumberGroup)


## 6.11.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$aircraftRegNumberGroup <- vuelosDeparted$aircraftRegNumberGroup
vuelosDeparted2$aircraft_registration_number <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$aircraftRegNumberGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$aircraft_registration_number == "XFGAT",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$aircraftRegNumberGroup)




###################################################################### 


## 6.12 routing (COMPLETADA)
## 6.12.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","routing"))
variables <- unique(df$routing)
mediaRutas <- mediasRetrasos(variables,df)
boxplot(mediaRutas$retrasoMedio)
barplot(mediaRutas$retrasoMedio, names.arg=mediaRutas$codigo)
summary(mediaRutas$retrasoMedio)
str(mediaRutas)

## 6.12.2. Segmentamos la variable en grupos en base a su retraso medio
## retraso medio inferior o igual a -3.4450
Rinf3 <- mediaRutas[mediaRutas$retrasoMedio <= (-3.4450),]
str(Rinf3)

## retraso medio entre -3.4450 y 0.7857 (incluido)
Rentre3y0 <- mediaRutas[mediaRutas$retrasoMedio > (-3.4450) & mediaRutas$retrasoMedio <= 0.7857,]
str(Rentre3y0)

## retraso medio entre 0.7857 y 5.4970 (incluido)
Rentre0y5 <- mediaRutas[mediaRutas$retrasoMedio > 0.7857 & mediaRutas$retrasoMedio <= 5.4970,]
str(Rentre0y5)

## retraso medio superior a 5.4970
Rsup5 <- mediaRutas[mediaRutas$retrasoMedio > 5.4970,]
str(Rsup5)

## los grupos en base a los cuartiles quedan de la siguiente forma
## retraso medio inferior o igual a -3.4450           -> 1
## retraso medio entre -3.4450 y 0.7857 (incluido)    -> 2
## retraso medio entre 0.7857 y 5.4970 (incluido)     -> 3
## retraso medio superior a 5.4970                    -> 4


## 6.12.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base a la ruta
cuartil1 <- quantile(mediaRutas$retrasoMedio,.25)
mediana <- quantile(mediaRutas$retrasoMedio,.50)
cuartil2 <- quantile(mediaRutas$retrasoMedio,.75)

mediaRutas$routingGroup <- asignarGrupoPorCuartiles(mediaRutas, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaRutas)
summary(mediaRutas)


## 6.12.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaRutas
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$routingGroup <- asignarGruposDF(vuelosDeparted$routing ,dfCodigoGrupo)
summary(vuelosDeparted$routingGroup)
str(vuelosDeparted$routingGroup)


## 6.12.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$routingGroup <- vuelosDeparted$routingGroup
vuelosDeparted2$routing <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$routingGroup==3,]
head(vuelosDeparted2[vuelosDeparted2$routing == "LEU-PNA",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$routingGroup)


###################################################################### 


## 6.13 mesSalida (COMPLETADA)
## 6.13.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","mesSalida"))
variables <- unique(df$mesSalida)
mediaMesSalida <- mediasRetrasos(variables,df)
boxplot(mediaMesSalida$retrasoMedio)
barplot(mediaMesSalida$retrasoMedio, names.arg=mediaMesSalida$codigo)
summary(mediaMesSalida$retrasoMedio)
str(mediaMesSalida)

## 6.13.2. Segmentamos la variable en grupos en base a su retraso medio
## retraso medio inferior o igual a -1.495
MSalInf <- mediaMesSalida[mediaMesSalida$retrasoMedio <= (-1.495),]
str(MSalInf)

## retraso medio entre -1.495 y -1.054 (incluido)
MsalEntre1y1 <- mediaMesSalida[mediaMesSalida$retrasoMedio > (-1.495) & mediaMesSalida$retrasoMedio <= (-1.054),]
str(MsalEntre1y1)

## retraso medio entre -1.054 y 0.000851 (incluido)
MsalEntre1y0 <- mediaMesSalida[mediaMesSalida$retrasoMedio > (-1.054) & mediaMesSalida$retrasoMedio <= 0.000851,]
str(MsalEntre1y0)

## retraso medio superior a 0.000851 
MsalSup0 <- mediaMesSalida[mediaMesSalida$retrasoMedio > 0.000851,]
str(MsalSup0)


## los grupos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a -1.495            -> 1
## retraso medio entre -1.495 y -1.054 (incluido)     -> 2
## retraso medio entre -1.054 y 0.000851 (incluido)   -> 3
## retraso medio superior a 0.000851                  -> 4

## 6.13.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al mes de salida
cuartil1 <- quantile(mediaMesSalida$retrasoMedio,.25)
mediana <- quantile(mediaMesSalida$retrasoMedio,.50)
cuartil2 <- quantile(mediaMesSalida$retrasoMedio,.75)

mediaMesSalida$mesSalidaGroup <- asignarGrupoPorCuartiles(mediaMesSalida, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaMesSalida)
summary(mediaMesSalida)


## 6.13.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaMesSalida
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$mesSalidaGroup <- asignarGruposDF(vuelosDeparted$mesSalida ,dfCodigoGrupo)
summary(vuelosDeparted$mesSalidaGroup)
str(vuelosDeparted$mesSalidaGroup)


## 6.13.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$mesSalidaGroup <- vuelosDeparted$mesSalidaGroup
vuelosDeparted2$mesSalida <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$mesSalidaGroup==3,]
head(vuelosDeparted2)
head(vuelosDeparted2[vuelosDeparted2$mesSalida == "6",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$mesSalidaGroup)


###################################################################### 


## 6.14 anyoSalida (COMPLETADA)
## No se analiza ya que solo tiene los valores 2015, 2016 y 2017

###################################################################### 


## 6.15 diaSalida (COMPLETADA)
## 6.15.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSalida"))
variables <- unique(df$diaSalida)
mediaDiaSalida <- mediasRetrasos(variables,df)
boxplot(mediaDiaSalida$retrasoMedio)
barplot(mediaDiaSalida$retrasoMedio, names.arg=mediaDiaSalida$codigo)
summary(mediaDiaSalida$retrasoMedio)
str(mediaDiaSalida)

## 6.15.2. Segmentamos la variable en grupos en base a su retraso medio
## retraso medio inferior o igual a -0.8889
dSalInf0 <- mediaDiaSalida[mediaDiaSalida$retrasoMedio <= (-0.8889),]
str(dSalInf0)

## retraso medio entre -0.8889 y -0.2294 (incluido)
dSalEntre08y02 <- mediaDiaSalida[mediaDiaSalida$retrasoMedio > (-0.8889) & mediaDiaSalida$retrasoMedio <= (-0.2294),]
str(dSalEntre08y02)

## retraso medio entre -0.2294 y 0.3652 (incluido)
dSalEntre02y03 <- mediaDiaSalida[mediaDiaSalida$retrasoMedio > (-0.2294) & mediaDiaSalida$retrasoMedio <= 0.3652,]
str(dSalEntre02y03)

## retraso medio superior a 0.3652
dSalSup03 <- mediaDiaSalida[mediaDiaSalida$retrasoMedio > 0.3652,]
str(dSalSup03)

## los grupos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a -0.8889           -> 1
## retraso medio entre -0.8889 y -0.2294 (incluido)   -> 2
## retraso medio entre -0.2294 y 0.3652 (incluido)    -> 3
## retraso medio superior a 0.3652                    -> 4

## 6.15.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al dia de salida
cuartil1 <- quantile(mediaDiaSalida$retrasoMedio,.25)
mediana <- quantile(mediaDiaSalida$retrasoMedio,.50)
cuartil2 <- quantile(mediaDiaSalida$retrasoMedio,.75)

mediaDiaSalida$diaSalidaGroup <- asignarGrupoPorCuartiles(mediaDiaSalida, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaDiaSalida)
summary(mediaDiaSalida)


## 6.15.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaDiaSalida
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$diaSalidaGroup <- asignarGruposDF(vuelosDeparted$diaSalida ,dfCodigoGrupo)
summary(vuelosDeparted$diaSalidaGroup)
str(vuelosDeparted$diaSalidaGroup)


## 6.15.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$diaSalidaGroup <- vuelosDeparted$diaSalidaGroup
vuelosDeparted2$diaSalida <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$diaSalidaGroup==3,]
head(vuelosDeparted2)
head(vuelosDeparted2[vuelosDeparted2$diaSalida == "11",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$diaSalidaGroup)

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
## retraso medio inferior o igual a 
## retraso medio entre y (incluido)
## retraso medio entre y (incluido)
## retraso medio superior a 

## los grupos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a 
## retraso medio entre y (incluido)
## retraso medio entre y (incluido)
## retraso medio superior a 

## 6.16.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base a la hora de salida
## 6.16.4 Añadir el nuevo vector al dataframe de vuelos
## 6.16.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.17 mesLlegada (COMPLETADA)
## 6.17.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","mesLlegada"))
variables <- unique(df$mesLlegada)
mediaMesLlegada <- mediasRetrasos(variables,df)
boxplot(mediaMesLlegada$retrasoMedio)
barplot(mediaMesLlegada$retrasoMedio, names.arg=mediaMesLlegada$codigo)
summary(mediaMesLlegada$retrasoMedio)
str(mediaMesLlegada)

## 6.17.2. Segmentamos la variable en grupos en base a su retraso medio
## retraso medio inferior o igual a -1.489
MLlegInf1 <- mediaMesLlegada[mediaMesLlegada$retrasoMedio <= (-1.489),]
str(MLlegInf1)

## retraso medio entre -1.489 y -1.071 (incluido)
MLlegEntre14y10 <- mediaMesLlegada[mediaMesLlegada$retrasoMedio > (-1.489) & mediaMesLlegada$retrasoMedio <= (-1.071),]
str(MLlegEntre14y10)

## retraso medio entre -1.071 y -0.01465 (incluido)
MLlegEntre10y00 <- mediaMesLlegada[mediaMesLlegada$retrasoMedio > (-1.071) & mediaMesLlegada$retrasoMedio <= (-0.01465),]
str(MLlegEntre10y00)

## retraso medio superior a -0.01465
MLlegSup00 <- mediaMesLlegada[mediaMesLlegada$retrasoMedio > (-0.01465),]
str(MLlegSup00)


## los grupos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a -1.489            -> 1
## retraso medio entre -1.489 y -1.071 (incluido)     -> 2
## retraso medio entre -1.071 y -0.01465 (incluido)   -> 3
## retraso medio superior a -0.01465                  -> 4

## 6.17.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al mes de llegada
cuartil1 <- quantile(mediaMesLlegada$retrasoMedio,.25)
mediana <- quantile(mediaMesLlegada$retrasoMedio,.50)
cuartil2 <- quantile(mediaMesLlegada$retrasoMedio,.75)

mediaMesLlegada$mesLlegadaGroup <- asignarGrupoPorCuartiles(mediaMesLlegada, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaMesLlegada)
summary(mediaMesLlegada)


## 6.17.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaMesLlegada
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$mesLlegadaGroup <- asignarGruposDF(vuelosDeparted$mesLlegada ,dfCodigoGrupo)
summary(vuelosDeparted$mesLlegadaGroup)
str(vuelosDeparted$mesLlegadaGroup)


## 6.17.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$mesLlegadaGroup <- vuelosDeparted$mesLlegadaGroup
vuelosDeparted2$mesLlegada <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$mesLlegadaGroup==3,]
head(vuelosDeparted2)
head(vuelosDeparted2[vuelosDeparted2$mesLlegada == "6",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$mesLlegadaGroup)

###################################################################### 


## 6.18 anyoLlegada (COMPLETADA)
## No se hace analisis ya que solo tiene los valores 2015, 2016 y 2017


###################################################################### 


## 6.19 diaLlegada (COMPLETADA)
## 6.19.1. Calculamos el retraso medio.
df <- subset(vuelosDeparted, select = c("arrival_delay","diaLlegada"))
variables <- unique(df$diaLlegada)
mediaDiaLlegada <- mediasRetrasos(variables,df)
boxplot(mediaDiaLlegada$retrasoMedio)
barplot(mediaDiaLlegada$retrasoMedio, names.arg=mediaDiaLlegada$codigo)
summary(mediaDiaLlegada$retrasoMedio)
str(mediaDiaLlegada)

## 6.19.2. Segmentamos la variable en grupos en base a su retraso medio
## retraso medio inferior o igual a -0.8248
diaLlegInf08 <- mediaDiaLlegada[mediaDiaLlegada$retrasoMedio <= (-0.8248),]
str(diaLlegInf08)

## retraso medio entre -0.8248 y -0.2593 (incluido)
diaLlegEntr08y02 <- mediaDiaLlegada[mediaDiaLlegada$retrasoMedio > (-0.8248) & mediaDiaLlegada$retrasoMedio <= (-0.2593),]
str(diaLlegEntr08y02)

## retraso medio entre -0.2583 y 0.3672 (incluido)
diaLlegEntr02y03 <- mediaDiaLlegada[mediaDiaLlegada$retrasoMedio > (-0.2593) & mediaDiaLlegada$retrasoMedio <= 0.3672,]
str(diaLlegEntr02y03)

## retraso medio superior a 0.3672
diaLlegSup03 <- mediaDiaLlegada[mediaDiaLlegada$retrasoMedio > 0.3672,]
str(diaLlegSup03)

## los grupos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a -0.8248           -> 1
## retraso medio entre -0.8248 y -0.2593 (incluido)   -> 2
## retraso medio entre -0.2583 y 0.3672 (incluido)    -> 3
## retraso medio superior a 0.3672                    -> 4

## 6.19.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base al dia de llegada
cuartil1 <- quantile(mediaDiaLlegada$retrasoMedio,.25)
mediana <- quantile(mediaDiaLlegada$retrasoMedio,.50)
cuartil2 <- quantile(mediaDiaLlegada$retrasoMedio,.75)

mediaDiaLlegada$diaLlegadaGroup <- asignarGrupoPorCuartiles(mediaDiaLlegada, cuartil1, mediana, cuartil2)
## Comprobamos que se han indicado correctamente los grupos
head(mediaDiaLlegada)
summary(mediaDiaLlegada)

## 6.19.4 Añadir el nuevo vector al dataframe de vuelos
## asignar el grupo a los datos del dataframe
dfCodigoGrupo <- mediaDiaLlegada
dfCodigoGrupo$retrasoMedio <- NULL
dfCodigoGrupo$numeroVuelos <- NULL

vuelosDeparted$diaLlegadaGroup <- asignarGruposDF(vuelosDeparted$diaLlegada ,dfCodigoGrupo)
summary(vuelosDeparted$diaLlegadaGroup)
str(vuelosDeparted$diaLlegadaGroup)


## 6.19.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada
vuelosDeparted2$diaLlegadaGroup <- vuelosDeparted$diaLlegadaGroup
vuelosDeparted2$diaLlegada <- NULL

## Comprobacion de asignacion de grupo
dfCodigoGrupo
head(vuelosDeparted2)
dfCodigoGrupo[dfCodigoGrupo$diaLlegadaGroup==3,]
head(vuelosDeparted2)
head(vuelosDeparted2[vuelosDeparted2$diaLlegada == "9",],4)

str(vuelosDeparted2)
summary(vuelosDeparted2$diaLlegadaGroup)

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
## retraso medio inferior o igual a 
## retraso medio entre y (incluido)
## retraso medio entre y (incluido)
## retraso medio superior a 

## los grupos en funcion de los cuartiles quedan de la siguiente forma:
## retraso medio inferior o igual a 
## retraso medio entre y (incluido)
## retraso medio entre y (incluido)
## retraso medio superior a 

## 6.20.3 Funcion para a?adir al dataframe una columna con los grupos obtenidos en base a la hora de llegada
## 6.20.4 Añadir el nuevo vector al dataframe de vuelos
## 6.20.5 Añadir nueva variable al dataframe resultante y eliminar la variable categorica analizada


###################################################################### 


## 6.21 diaSemanaSalida (COMPLETADA)
## 6.22.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSemanaSalida"))
variables <- unique(df$diaSemanaSalida)
mediaDiaSemSalida <- mediasRetrasos(variables,df)
boxplot(mediaDiaSemSalida$retrasoMedio)
barplot(mediaDiaSemSalida$retrasoMedio, names.arg=mediaDiaSemSalida$codigo)
summary(mediaDiaSemSalida$retrasoMedio)
str(mediaDiaSemSalida)


###################################################################### 


## 6.22 disSemanaLlegada (COMPLETADA)
## 6.22.1. Calculamos el retraso medio
df <- subset(vuelosDeparted, select = c("arrival_delay","diaSemanaLlegada"))
variables <- unique(df$diaSemanaLlegada)
mediaDiaSemLlegada <- mediasRetrasos(variables,df)
boxplot(mediaDiaSemLlegada$retrasoMedio)
barplot(mediaDiaSemLlegada$retrasoMedio, names.arg=mediaDiaSemLlegada$codigo)
summary(mediaDiaSemLlegada$retrasoMedio)
str(mediaDiaSemLlegada)


###################################################################### 






#####################################################################################################
########## ELIMINAR VARIABLES CATEGORICAS ANALIZADAS Y SIN ANALIZAR QUE NO TENGAN SENTIDO MANTENER

## COMPROBAR CORRELACION ENTRE VARIABLES
tabla1 <- table(vuelosDeparted$board_point, vuelosDeparted$off_point)
plot(tabla1, col = c("red", "blue"), main = "dia semana Llegada vs. dia semana Salida")
chisq.test(tabla1)
## En base al valor de P-value determinamos que hay dependencia entre estas dos variables.
## Si p-value es menor que 0.05 determinamos que hay dependencia
## si p-value es mayor que 0.05 determinamos que no hay dependencia





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
